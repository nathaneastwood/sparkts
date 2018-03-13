Building Expected Data Outputs
================

# The Problem

You may see the following issue when testing:

``` r
expect_identical(
  output,
  expected_df
)
# Error: `output` not identical to `expected_df`.
# Rows in x but not y: 8, 7, 6, 5, 4, 3, 2, 1. Rows in y but not x: 8, 7, 6, 5, 4, 3, 2, 1.
```

If you use `dput` to generate your expected output, it doesn’t store the
full numeric data information. To prove this, rounding this information
allows the test to pass:

``` r
expect_identical(
  output %>% dplyr::mutate(stdError = round(stdError, 2)),
  expected_df %>% dplyr::mutate(stdError = round(stdError, 2))
)
```

# Solution

One way we can keep the full numeric data information is using
hexadecimal (binary fractions) data. See `?deparseOpts` for more
information.

``` r
expected_df <- dput(
  output, control = c("keepNA", "keepInteger", "showAttributes", "hexNumeric")
)
# structure(list(ref = c("000000000", "111111111", "222222222", 
# "333333333", "444444444", "555555555", "666666666", "777777777"
# ), xColumn = c("200", "300", "400", "500", "600", "700", "800", 
# "900"), yColumn = c(0x1.ep+6, 0x1.b8p+7, 0x1.4p+8, 0x1.a4p+8, 
# 0x1.04p+9, 0x1.36p+9, 0x1.68p+9, 0x1.9ap+9), zColumn = c(0x1.4p+3, 
# 0x1.4p+4, 0x1.ep+4, 0x1.4p+5, 0x1.a8p+5, 0x1.ep+5, 0x1.18p+6, 
# 0x1.4p+6), stdError = c(0x1.52b952c7bcc28p+3, 0x1.c3b3c2c7f7456p+3, 
# 0x1.0cbf977caebe5p+4, 0x1.312017f7c1e86p+4, 0x1.65a0af5bc89b2p+4, 
# 0x1.6eb60bd6012a1p+4, 0x1.89cd2c252fef2p+4, 0x1.a31bfdcc2b158p+4
# )), .Names = c("ref", "xColumn", "yColumn", "zColumn", "stdError"
# ), row.names = c(NA, -8L), class = c("tbl_df", "tbl", "data.frame"
# ))
```

Then when we compare the two datasets, we see no errors.

``` r
expect_identical(
  output,
  expected_df
)
```

If you don’t want to use hexadecimal units, for whatever reason, you can
get away with using `expect_equal()` instead of `expect_identical()`
which adds a tolerance to numerical value comparisons. See `?all.equal`
for more information.
