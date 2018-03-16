context("Test the sdf_lag function")

sc <- testthat_spark_connection()

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

  # Send the method output and expected output to a file
  tmp_sink_file_name <- tempfile(fileext = ".txt")
  tmp_sink_file_num <- file(tmp_sink_file_name, open = "wt")
  send_output(
    file = tmp_sink_file_name,
    name = "sdf_lag",
    output = output,
    expected = expected_sdf_lag
  )
  close(tmp_sink_file_num)

  # Test the expectation
  tryCatch({
    expect_identical(
      output,
      expected_sdf_lag
    )
  },
  error = function(e) {
    cat("\n   Output data can be seen in ", tmp_sink_file_name, "\n", sep = "")
  }
  )
  expect_identical(
    output,
    expected_sdf_lag
  )

})
