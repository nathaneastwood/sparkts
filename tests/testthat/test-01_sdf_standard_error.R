context("Test the sdf_standard_error function")

sc <- testthat_spark_connection()

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

  # Send the method output and expected output to a file
  tmp_sink_file_name <- tempfile(fileext = ".txt")
  tmp_sink_file_num <- file(tmp_sink_file_name, open = "wt")
  send_output(
    file = tmp_sink_file_name,
    name = "sdf_standard_error",
    output = output,
    expected = expected_sdf_standard_error
  )
  close(tmp_sink_file_num)

  # Test the expectation
  tryCatch({
    expect_identical(
      output,
      expected_sdf_standard_error
    )
  },
  error = function(e) {
    cat("\n   Output data can be seen in ", tmp_sink_file_name, "\n", sep = "")
  }
  )
  expect_identical(
    output,
    expected_sdf_standard_error
  )
})
