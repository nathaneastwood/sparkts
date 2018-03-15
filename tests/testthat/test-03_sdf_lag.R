context("Test the sdf_lag function")

test_that("Ensure the Lag method returns the expected output", {

  # Read in the data
  lag_std_data <- sparklyr::spark_read_json(
    sc,
    "lag_std_data",
    path = system.file(
      "data_raw/lag_data.json",
      package = "sparkts"
    )
  ) %>%
    sparklyr::spark_dataframe()

  # Instantiate the class
  output <- sdf_lag(
    sc = sc, data = lag_std_data,
    partition_cols = "id", order_cols = "t", target_col = "v", lag_num = 2L
  ) %>%
    dplyr::collect()

  # Test the expectation
  expect_identical(
    output,
    expected_sdf_lag
  )

})
