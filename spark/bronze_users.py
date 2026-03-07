from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("BronzeUsersStreaming") \
    .master("spark://spark-master:7077") \
    .config("spark.cores.max", "1") \
    .config("spark.executor.cores", "1") \
    .config("spark.executor.memory", "1g") \
    .config("spark.sql.shuffle.partitions", "2") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

kafka_df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "kafka:29092") \
    .option("subscribe", "saas.public.users") \
    .option("startingOffsets", "earliest") \
    .load()

bronze_df = kafka_df.selectExpr("CAST(value AS STRING) as json_value")

query = bronze_df.writeStream \
    .format("delta") \
    .option("checkpointLocation", "/delta/checkpoints/bronze/users") \
    .start("/delta/bronze/users")

query.awaitTermination()