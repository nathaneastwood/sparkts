# Create the connection to a local spark cluster
sc <- sparklyr::spark_connect(
  master = "local",
  version = "2.2.0",
  config = list(sparklyr.gatway.address = "127.0.0.1")
)
