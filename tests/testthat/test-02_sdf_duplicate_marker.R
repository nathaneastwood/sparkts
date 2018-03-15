context("Test the sdf_duplicate_marker function")

test_that("Ensure the Duplicate Marker function returns the expected output", {

  # Read in the data
  dup_std_data <- sparklyr::spark_read_json(
    sc,
    "dup_std_data",
    path = system.file(
      "data_raw/DuplicateDataIn.json",
      package = "sparkts"
    )
  ) %>%
    sparklyr::spark_dataframe()

  # Instantiate the class
  output <- sdf_duplicate_marker(
    sc = sc, data = dup_std_data,
    partcol = "num", ordcol = "order", new_col = "marker"
  ) %>%
    dplyr::collect()

  # Test the expectation
  expect_identical(
    output,
    expected_sdf_duplicate_marker
  )

})
