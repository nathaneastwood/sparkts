context("scala-methods")

# Create the connection to a local spark cluster
sc <- sparklyr::spark_connect(master = "local", version = "2.2.0")

test_that("Test that the standard error calculations are as expected", {

  # Read in the data
  std_data <- sparklyr::spark_read_json(
    sc,
    "std_data",
    path = system.file(
      "data_raw/StandardErrorDataIn.json",
      package = "sparkts"
    )
  ) %>%
    sparklyr::spark_dataframe()

  # Instantiate the class
  output <- sdf_standard_error(
    sc = sc, data = std_data,
    x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
    new_column_name = "StandardError"
  ) %>%
    dplyr::collect()

  # Test the expectation
  expect_identical(
    output %>% dplyr::select(-dplyr::contains("Error")),
    expected_sdf_standard_error %>% dplyr::select(-dplyr::contains("Error"))
  )
  expect_equivalent(
    output[["StandardError"]],
    expected_sdf_standard_error[["stdError"]]
  )
})

# Disconnect from the cluster
sparklyr::spark_disconnect(sc = sc)
