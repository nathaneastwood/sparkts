context("Test the sdf_standard_error function")

test_that("Test the standard error calculations are as expected", {

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

  # Call the method
  output <- sdf_standard_error(
    sc = sc, data = std_data,
    x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
    new_column_name = "stdError"
  ) %>%
    dplyr::collect()

  # Test the expectation
  expect_identical(
    output,
    expected_sdf_standard_error
  )
})
