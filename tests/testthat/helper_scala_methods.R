expected_sdf_standard_error <- structure(
  list(
    ref = c(
      "000000000", "111111111", "222222222",
      "333333333", "444444444", "555555555", "666666666", "777777777"
    ), xColumn = c(
      "200", "300", "400", "500", "600", "700", "800",
      "900"
    ), yColumn = c(
      0x1.ep+6, 0x1.b8p+7, 0x1.4p+8, 0x1.a4p+8,
      0x1.04p+9, 0x1.36p+9, 0x1.68p+9, 0x1.9ap+9
    ), zColumn = c(
      0x1.4p+3,
      0x1.4p+4, 0x1.ep+4, 0x1.4p+5, 0x1.a8p+5, 0x1.ep+5, 0x1.18p+6,
      0x1.4p+6
    ), stdError = c(
      0x1.52b952c7bcc28p+3, 0x1.c3b3c2c7f7456p+3,
      0x1.0cbf977caebe5p+4, 0x1.312017f7c1e86p+4, 0x1.65a0af5bc89b2p+4,
      0x1.6eb60bd6012a1p+4, 0x1.89cd2c252fef2p+4, 0x1.a31bfdcc2b158p+4
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
