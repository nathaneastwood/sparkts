context("Test the sdf_duplicate_marker function")

sc <- testthat_spark_connection()

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
    part_col = "num", ord_col = "order", new_column_name = "marker"
  ) %>%
    dplyr::collect()

  # Send the method output and expected output to a file
  tmp_sink_file_name <- tempfile(fileext = ".txt")
  tmp_sink_file_num <- file(tmp_sink_file_name, open = "wt")
  send_output(
    file = tmp_sink_file_name,
    name = "sdf_duplicate_marker",
    output = output,
    expected = expected_sdf_duplicate_marker
  )
  close(tmp_sink_file_num)

  # Test the expectation
  tryCatch({
    expect_identical(
      output,
      expected_sdf_duplicate_marker
    )
  },
  error = function(e) {
    cat("\n   Output data can be seen in ", tmp_sink_file_name, "\n", sep = "")
  }
  )
  expect_identical(
    output,
    expected_sdf_duplicate_marker
  )

})
