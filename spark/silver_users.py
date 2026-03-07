from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_unixtime, row_number, from_json
from pyspark.sql.window import Window
from delta.tables import DeltaTable

spark = SparkSession.builder \
    .appName("SilverUsersStreaming") \
    .master("spark://spark-master:7077") \
    .config("spark.cores.max","1") \
    .config("spark.executor.cores","1") \
    .config("spark.executor.memory","1g") \
    .getOrCreate()

bronze_path = "/delta/bronze/users"
current_path = "/delta/silver/users_current"

# Ensure Silver table exists once
if not DeltaTable.isDeltaTable(spark, current_path):
    empty_df = spark.createDataFrame([], schema="""
        user_id INT,
        email STRING,
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
                    user_id: INT,
                    email: STRING
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
        col("after.user_id").alias("user_id"),
        col("after.email").alias("email"),
        col("op").alias("operation"),
        col("ts_ms").alias("event_ts")
    ).withColumn(
        "event_time",
        from_unixtime(col("event_ts") / 1000)
    )

    window = Window.partitionBy("user_id") \
        .orderBy(col("event_ts").desc())

    silver_latest = silver_df \
        .withColumn("rn", row_number().over(window)) \
        .filter(col("rn") == 1) \
        .drop("rn")

    delta_table = DeltaTable.forPath(spark, current_path)

    delta_table.alias("target").merge(
        silver_latest.alias("source"),
        "target.user_id = source.user_id"
    ).whenMatchedUpdate(
        condition="source.operation != 'd'",
        set={
            "email": "source.email",
            "operation": "source.operation",
            "event_ts": "source.event_ts",
            "event_time": "source.event_time"
        }
    ).whenMatchedDelete(
        condition="source.operation = 'd'"
    ).whenNotMatchedInsertAll().execute()

    print(f"Batch {batch_id} merged successfully.")

query = bronze_df.writeStream \
    .foreachBatch(upsert_to_silver) \
    .option("checkpointLocation", "/delta/checkpoints/silver_users") \
    .outputMode("append") \
    .start()

query.awaitTermination()