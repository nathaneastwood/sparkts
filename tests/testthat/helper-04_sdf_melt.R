expected_sdf_melt <-
  structure(
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
