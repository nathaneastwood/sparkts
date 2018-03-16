context("Test the sdf_melt function")

sc <- testthat_spark_connection()

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
    sc = sc,
    data = melt_std_data,
    id_variables = c("identifier", "date"),
    value_variables = c("two", "one", "three", "four"),
    variable_name = "variable",
    value_name = "turnover"
  ) %>%
    dplyr::collect()

  # Send the method output and expected output to a file
  tmp_sink_file_name <- tempfile(fileext = ".txt")
  tmp_sink_file_num <- file(tmp_sink_file_name, open = "wt")
  send_output(
    file = tmp_sink_file_name,
    name = "sdf_melt",
    output = output,
    expected = expected_sdf_melt
  )
  close(tmp_sink_file_num)

  # Test the expectation
  tryCatch({
    expect_identical(
      output,
      expected_sdf_melt
    )
  },
  error = function(e) {
    cat("\n   Output data can be seen in ", tmp_sink_file_name, "\n", sep = "")
  }
  )
  expect_identical(
    output,
    expected_sdf_melt
  )

})
