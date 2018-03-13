expected_sdf_standard_error <- structure(
  list(
    ref = c(
      "000000000", "111111111", "222222222", "333333333", "444444444",
      "555555555", "666666666", "777777777"
    ),
    xColumn = c("200", "300", "400", "500", "600", "700", "800", "900"),
    yColumn = c(120, 220, 320, 420, 520, 620, 720, 820),
    zColumn = c(10, 20, 30, 40, 53, 60, 70, 80),
    stdError = c(
      10.5851224804993, 14.1156934648117, 16.7967753286756,
      19.0703353574777, 22.351729734926, 22.9194448813965,
      24.6125909283282, 26.1943338370632
    )
  ),
  .Names = c("ref", "xColumn", "yColumn", "zColumn", "stdError"),
  row.names = c(NA, -8L),
  class = c("tbl_df", "tbl", "data.frame")
)
#Sum_col test data A
expected_sdf_sum_col_df1 <- structure(list(
  Period = c(
    "2015Q1", "2015Q2", "2015Q3", "2015Q4",
    "2015Q1", "2015Q2", "2015Q3", "2015Q4", "2015Q1", "2015Q2", "2015Q3",
    "2015Q4", "2015Q1", "2015Q2", "2015Q3", "2015Q4", "2015Q1", "2015Q2",
    "2015Q3", "2015Q4"
  ),
  Region = c(
    "England", "England", "England",
    "England", "Ireland", "Ireland", "Ireland", "Ireland", "N. Ireland",
    "N. Ireland", "N. Ireland", "N. Ireland", "Scotland", "Scotland",
    "Scotland", "Scotland", "Wales", "Wales", "Wales", "Wales"
  ),
  sum_of_Sales_Rounded_GBP = c(
    0x1.438ep+15, 0x1.4406p+15,
    0x1.59b4p+15, 0x1.37ccp+15, 0x1.1308p+13, 0x1.0608p+13, 0x1.2a98p+13,
    0x1.c87p+12, 0x1.91p+13, 0x1.b21p+13, 0x1.f5p+13, 0x1.2228p+14,
    0x1.0608p+15, 0x1.d0ep+14, 0x1.e26p+14, 0x1.0cb8p+15, 0x1.8b94p+14,
    0x1.afacp+14, 0x1.e558p+14, 0x1.455p+14
  )
),
.Names = c( "Period", "Region", "sum_of_Sales_Rounded_GBP"
),
row.names = c(NA, -20L),
class = c("tbl_df", "tbl", "data.frame")
)
#Sum_col test data B
expected_sdf_sum_col_df2 <-
  structure(list(
    Department = c(
    "Clothing", "DIY", "Electronics",
    "Garden", "Household", "Jewellery", "Toys"
  ),
  sum_of_Sales_Rounded_GBP = c(
    0x1.f068p+16,
    0x1.14b4p+15, 0x1.f63p+16, 0x1.6f7p+15, 0x1.3ee2p+16, 0x1.acfcp+15,
    0x1.4ac8p+14
  )),
  .Names = c("Department", "sum_of_Sales_Rounded_GBP"),
  row.names = c(NA, -7L),
  class = c("tbl_df", "tbl", "data.frame")
  )
