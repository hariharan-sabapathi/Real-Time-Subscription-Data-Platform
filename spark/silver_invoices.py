from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_unixtime, row_number, from_json
from pyspark.sql.window import Window
from delta.tables import DeltaTable

spark = SparkSession.builder \
    .appName("SilverInvoicesStreaming") \
    .master("spark://spark-master:7077") \
    .config("spark.cores.max", "1") \
    .config("spark.executor.cores", "1") \
    .config("spark.executor.memory", "1g") \
    .getOrCreate()

bronze_path = "/delta/bronze/invoices"
current_path = "/delta/silver/invoices_current"

# Ensure Silver table exists
if not DeltaTable.isDeltaTable(spark, current_path):
    empty_df = spark.createDataFrame([], schema="""
        invoice_id INT,
        subscription_id INT,
        amount DOUBLE,
        status STRING,
        operation STRING,
        event_ts LONG,
        event_time TIMESTAMP
    """)
    empty_df.write.format("delta").mode("overwrite").save(current_path)

bronze_raw = spark.readStream.format("delta").load(bronze_path)

bronze_parsed = bronze_raw.selectExpr(
    "CAST(json_value AS STRING) as json_str"
).select(
    from_json(
        "json_str",
        """
        STRUCT<
            payload: STRUCT<
                after: STRUCT<
                    invoice_id: INT,
                    subscription_id: INT,
                    amount: DOUBLE,
                    status: STRING
                >,
                op: STRING,
                ts_ms: LONG
            >
        >
        """
    ).alias("data")
)

bronze_df = bronze_parsed.select("data.payload.*")

def upsert_to_silver(batch_df, batch_id):

    if batch_df.rdd.isEmpty():
        return

    silver_df = batch_df.select(
        col("after.invoice_id").alias("invoice_id"),
        col("after.subscription_id").alias("subscription_id"),
        col("after.amount").alias("amount"),
        col("after.status").alias("status"),
        col("op").alias("operation"),
        col("ts_ms").alias("event_ts")
    ).withColumn(
        "event_time",
        from_unixtime(col("event_ts") / 1000)
    )

    window = Window.partitionBy("invoice_id").orderBy(col("event_ts").desc())

    silver_latest = silver_df \
        .withColumn("rn", row_number().over(window)) \
        .filter(col("rn") == 1) \
        .drop("rn")

    delta_table = DeltaTable.forPath(spark, current_path)

    delta_table.alias("target").merge(
        silver_latest.alias("source"),
        "target.invoice_id = source.invoice_id"
    ).whenMatchedUpdate(
        condition="source.operation != 'd'",
        set={
            "subscription_id": "source.subscription_id",
            "amount": "source.amount",
            "status": "source.status",
            "operation": "source.operation",
            "event_ts": "source.event_ts",
            "event_time": "source.event_time"
        }
    ).whenMatchedDelete(
        condition="source.operation = 'd'"
    ).whenNotMatchedInsertAll().execute()

query = bronze_df.writeStream \
    .foreachBatch(upsert_to_silver) \
    .option("checkpointLocation", "/delta/checkpoints/silver_invoices") \
    .outputMode("append") \
    .start()

query.awaitTermination()