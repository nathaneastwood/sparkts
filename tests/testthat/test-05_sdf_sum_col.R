context("Test the sdf_sum_col function")

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
  sumcol_actual_data <- sdf_sum_col(
    sc = sc, data = sumcol_data_in,
    group_by_cols = c("Region", "Period"), sum_col_name = "Sales_Rounded_GBP"
  ) %>%
    dplyr::collect() %>%
    dplyr::select(Region, Period, sum_of_Sales_Rounded_GBP) %>%
    dplyr::distinct(Region, Period, sum_of_Sales_Rounded_GBP)

  cat("\n Sum Col :: groupby two columns :: Actual dataframe out\n")
  print(sumcol_actual_data)
  cat("\n Sum Col :: groupby two columns :: Expected dataframe out\n")
  print(dplyr::collect(expected_sdf_sum_col_df1 %>%
                         dplyr::select(Region, Period,
                                       sum_of_Sales_Rounded_GBP)))
  # Test the expectation
  expect_identical(
    sumcol_actual_data,
    expected_sdf_sum_col_df1 %>%
      dplyr::select(Region, Period, sum_of_Sales_Rounded_GBP)
  )
  expect_equivalent(
    sumcol_actual_data[["sum_of_Sales_Rounded_GBP"]],
    expected_sdf_sum_col_df1[["sum_of_Sales_Rounded_GBP"]]
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
  sumcol_actual_data <- sdf_sum_col(
    sc = sc, data = sumcol_data_in,
    group_by_cols = c("Department"), sum_col_name = "Sales_Rounded_GBP"
  ) %>%
    dplyr::collect() %>%
    dplyr::select(Department, sum_of_Sales_Rounded_GBP) %>%
    dplyr::distinct(Department, sum_of_Sales_Rounded_GBP)

  cat("\n Sum Col :: groupby one column :: Actual dataframe out\n")
  print(sumcol_actual_data)
  cat("\n Sum Col :: groupby one column :: Expected dataframe out\n")
  print(dplyr::collect(expected_sdf_sum_col_df2 %>%
                         dplyr::select(Department, sum_of_Sales_Rounded_GBP)))
  # Test the expectation
  expect_identical(
    sumcol_actual_data,
    expected_sdf_sum_col_df2 %>%
      dplyr::select(Department, sum_of_Sales_Rounded_GBP)
  )
  expect_equivalent(
    sumcol_actual_data[["sum_of_Sales_Rounded_GBP"]],
    expected_sdf_sum_col_df2[["sum_of_Sales_Rounded_GBP"]]
  )
})
