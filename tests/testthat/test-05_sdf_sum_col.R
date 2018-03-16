context("Test the sdf_sum_col function")

sc <- testthat_spark_connection()

test_that("Test the sum_col method by passing two group by columns", {

  # Read in the data
  sumcol_data_in <- sparklyr::spark_read_json(
    sc,
    "sumcol_data_in",
    path = system.file(
      "data_raw/SumCol_RAW.json",
      package = "sparkts"
    )
  ) %>%
    sparklyr::spark_dataframe()

  # Instantiate the class
  output <- sdf_sum_col(
    sc = sc, data = sumcol_data_in,
    group_by_cols = c("Region", "Period"), sum_col_name = "Sales_Rounded_GBP"
  ) %>%
    dplyr::collect() %>%
    dplyr::select(Period, Region, sum_of_Sales_Rounded_GBP) %>%
    dplyr::distinct(Period, Region, sum_of_Sales_Rounded_GBP)

  # Send the method output and expected output to a file
  tmp_sink_file_name <- tempfile(fileext = ".txt")
  tmp_sink_file_num <- file(tmp_sink_file_name, open = "wt")
  send_output(
    file = tmp_sink_file_name,
    name = "sdf_sum_col",
    output = output,
    expected = expected_sdf_sum_col_df1
  )
  close(tmp_sink_file_num)

  # Test the expectation
  tryCatch({
    expect_identical(
      output,
      expected_sdf_sum_col_df1
    )
  },
  error = function(e) {
    cat("\n   Output data can be seen in ", tmp_sink_file_name, "\n", sep = "")
  }
  )
  expect_identical(
    output,
    expected_sdf_sum_col_df1
  )
})

test_that("Test the sum col method by passing one group by column", {

  # Read in the data
  sumcol_data_in <- sparklyr::spark_read_json(
    sc,
    "sumcol_data_in",
    path = system.file(
      "data_raw/SumCol_RAW.json",
      package = "sparkts"
    )
  ) %>%
    sparklyr::spark_dataframe()

  # Instantiate the class
  output <- sdf_sum_col(
    sc = sc, data = sumcol_data_in,
    group_by_cols = c("Department"), sum_col_name = "Sales_Rounded_GBP"
  ) %>%
    dplyr::collect() %>%
    dplyr::select(Department, sum_of_Sales_Rounded_GBP) %>%
    dplyr::distinct(Department, sum_of_Sales_Rounded_GBP)

  # Send the method output and expected output to a file
  tmp_sink_file_name <- tempfile(fileext = ".txt")
  tmp_sink_file_num <- file(tmp_sink_file_name, open = "wt")
  send_output(
    file = tmp_sink_file_name,
    name = "sdf_sum_col",
    output = output,
    expected = expected_sdf_sum_col_df2
  )
  close(tmp_sink_file_num)

  # Test the expectation
  tryCatch({
    expect_identical(
      output,
      expected_sdf_sum_col_df2
    )
  },
  error = function(e) {
    cat("\n   Output data can be seen in ", tmp_sink_file_name, "\n", sep = "")
  }
  )
  expect_identical(
    output,
    expected_sdf_sum_col_df2
  )
})
