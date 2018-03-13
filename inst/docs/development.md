Developing the Package
================

# Development Advice

Developing this package further will require a working knowledge of
several packages. Detailed below are several links to books, packages
and vignettes.

  - Tools to make an R developer’s life easier:
    [devtools](https://github.com/r-lib/devtools)
  - Keep your code and code documentation together using
    [Roxygen2](https://github.com/klutometis/roxygen): Check out the
    vignettes [here](https://cran.r-project.org/web/packages/roxygen2/)
  - Test your code with [testthat](https://github.com/r-lib/testthat)

You can read about these tools and the wider R package development world
in the [R Packages](http://r-pkgs.had.co.nz) book.

Key functions to know about are:

  - devtools::document()
  - devtools::test()
  - devtools::check()
  - devtools::build()

A very good (free) book on general R can be found
[here](https://adv-r.hadley.nz).

All of the packages I have mentioned come from the
“[tidyverse](https://www.tidyverse.org)” which is a collection of
packages that work very well together. A key package which works well
with [sparklyr](http://spark.rstudio.com) is called
[dplyr](http://dplyr.tidyverse.org). dplyr provides a grammar of data
manipulation, providing a consistent set of verbs that solve the most
common data manipulation challenges. It is the package to use for data
manipulation in R and is R’s version of the Python pandas library.

# Generating HTML Documentation

We can generate the HTML from an Rd file using the following code.

``` r
tools::Rd2HTML("../../man/scala_list.Rd")
# <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>R: Generate a Scala List</title>
# <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
# <link rel="stylesheet" type="text/css" href="R.css" />
# </head><body>
# 
# <table width="100%" summary="page for scala_list"><tr><td>scala_list</td><td style="text-align: right;">R Documentation</td></tr></table>
# 
# <h2>Generate a Scala List</h2>
# 
# <h3>Description</h3>
# 
# <p>Scala List cannot be generated using sparklyr. We must generate them using
# this function.
# </p>
# 
# 
# <h3>Usage</h3>
# 
# <pre>
# scala_list(sc, x)
# </pre>
# 
# 
# <h3>Arguments</h3>
# 
# <table summary="R argblock">
# <tr valign="top"><td><code>sc</code></td>
# <td>
# <p>A <code>spark_connection</code>.</p>
# </td></tr>
# <tr valign="top"><td><code>x</code></td>
# <td>
# <p>A vector.</p>
# </td></tr>
# </table>
# 
# 
# <h3>Examples</h3>
# 
# <pre>
# ## Not run: 
# sc &lt;- sparklyr::spark_connect(master = "local", version = "2.2.0")
# sparkts:::scala_list(sc, c(1, 2, 3))
# sparklyr::spark_disconnect(sc = sc)
# 
# ## End(Not run)
# </pre>
# 
# 
# </body></html>
```

This is linked to JIRA ticket
[DAPS-433](https://collaborate2.ons.gov.uk/jira/browse/DAPS-433).

# Building Expected Data Outputs

## The Problem

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

## Solution

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
