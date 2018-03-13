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


expected_sdf_duplicate_marker <- structure(
  list(
    id = c(0x1p+0, 0x1p+1, 0x1p+0, 0x1p+0),
    num = c(0x1p+2, 0x1p+2, 0x1p+2, 0x1.4p+2),
    order = c(0x1p+0, 0x1p+0, 0x1p+1, 0x1.8p+1),
    marker = c(1L, 0L, 0L, 1L)
  ),
  .Names = c("id", "num", "order", "marker"),
  row.names = c(NA, -4L),
  class = c("tbl_df", "tbl", "data.frame")
)

expected_sdf_lag <- structure(
  list(
    id = c(0x1p+1, 0x1p+1, 0x1p+0, 0x1p+0, 0x1p+0),
    t = c(0x1p+0, 0x1p+1, 0x1p+0, 0x1p+1, 0x1.8p+1),
    v = c(0x1.5p+4, 0x1.6p+4, 0x1.6p+3, 0x1.8p+3, 0x1.ap+3),
    lagged1 = c(NaN, 0x1.5p+4, NaN, 0x1.6p+3, 0x1.8p+3),
    lagged2 = c(NaN, NaN, NaN, NaN, 0x1.6p+3)
  ),
  .Names = c("id", "t", "v", "lagged1", "lagged2"),
  row.names = c(NA, -5L),
  class = c("tbl_df", "tbl", "data.frame")
)

expected_sdf_melt <- structure(
  list(
    identifier = c("qwer", "qwer", "qwer", "qwer",
                   "qwer", "qwer", "qwer", "qwer",
                   "tyui", "tyui", "tyui", "tyui",
                   "opas", "opas", "opas", "opas",
                   "dfgh", "dfgh", "dfgh", "dfgh",
                   "jklz", "jklz", "jklz", "jklz"),
    date = c("201702", "201702", "201702", "201702",
             "201701", "201701", "201701", "201701",
             "201701", "201701", "201701", "201701",
             "201701", "201701", "201701", "201701",
             "201701", "201701", "201701", "201701",
             "201701", "201701", "201701", "201701"),
    variable = c("two", "one", "three", "four", "two",
                 "one", "three", "four", "two", "one",
                 "three", "four", "two",
                 "one", "three", "four", "two", "one", "three", "four", "two",
                 "one", "three", "four"),
    turnover = c(0x1.58p+5, 0x1.04p+6, 0x1.4p+3, 0x1.9p+5,
                 0x1.58p+5, 0x1.04p+6, 0x1.4p+3, 0x1.9p+5,
                 0x1.7p+4, 0x1.1p+5, 0x1.4p+4, 0x1.9p+5,
                 0x1.08p+5, 0x1.7p+4, 0x1.ep+4, 0x1.9p+5,
                 0x1.5p+4, 0x1p+5, 0x1.4p+5, 0x1.9p+5,
                 0x1.3p+4, 0x1.48p+5, 0x1.9p+5, 0x1.9p+5)
  ),
  .Names = c("identifier", "date", "variable", "turnover"),
  row.names = c(NA, -24L),
  class = c("tbl_df", "tbl", "data.frame")
)
