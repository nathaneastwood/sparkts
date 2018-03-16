expected_sdf_lag <-
  structure(
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
