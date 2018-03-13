context("scala-methods")

# Create the connection to a local spark cluster
sc <- sparklyr::spark_connect(master = "local", version = "2.2.0")

test_that("Test that the standard error calculations are as expected", {

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

  # Instantiate the class
  output <- sdf_standard_error(
    sc = sc, data = std_data,
    x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
    new_column_name = "StandardError"
  ) %>%
    dplyr::collect()

  # Test the expectation
  expect_identical(
    output %>% dplyr::select(-dplyr::contains("Error")),
    expected_sdf_standard_error %>% dplyr::select(-dplyr::contains("Error"))
  )
  expect_equivalent(
    output[["StandardError"]],
    expected_sdf_standard_error[["stdError"]]
  )
})

test_that("Test that the sum col method by passing two group by columns", {

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
  )  %>% dplyr::collect() %>%
    dplyr::select(Region, Period, sum_of_Sales_Rounded_GBP) %>%
    dplyr::distinct(Region, Period, sum_of_Sales_Rounded_GBP)

  cat("\n Sum Col :: groupby two columns :: Actual dataframe out\n")
  print(sumcol_actual_data)
  cat("\n Sum Col :: groupby two columns :: Expected dataframe out\n")
  print(dplyr::collect(expected_sdf_sum_col_df1 %>%
        dplyr::select(Region, Period, sum_of_Sales_Rounded_GBP)))
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

test_that("Test that the sum col method by passing one group by column", {

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
  )  %>% dplyr::collect() %>%
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

# Disconnect from the cluster
sparklyr::spark_disconnect(sc = sc)
