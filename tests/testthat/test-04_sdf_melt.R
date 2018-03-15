context("Test the sdf_melt function")

test_that("Ensure the melt method returns the expected output", {

  # Read in the data
  melt_std_data <- sparklyr::spark_read_json(
    sc,
    "melt_std_data",
    path = system.file(
      "data_raw/Melt.json",
      package = "sparkts"
    )
  ) %>%
    sparklyr::spark_dataframe()

  # Instantiate the class
  output <- sdf_melt(
    sc = sc, data = melt_std_data,
    id_variables = c("identifier", "date"),
    value_variables = c("two", "one", "three", "four"),
    variable_name = "variable",
    value_name = "turnover"
  ) %>%
    dplyr::collect()

  # Test the expectation
  expect_identical(
    output,
    expected_sdf_melt
  )

})
