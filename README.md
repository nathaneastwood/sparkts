
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sparkts

[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/sparkts)](http://cran.r-project.org/package=sparkts)
[![Travis-CI Build
Status](https://travis-ci.org/nathaneastwood/sparkts.svg?branch=master)](https://travis-ci.org/nathaneastwood/sparkts)
[![Coverage
Status](https://img.shields.io/codecov/c/github/nathaneastwood/sparkts/master.svg)](https://codecov.io/github/nathaneastwood/sparkts?branch=master)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The goal of sparkts is to provide a test bed of `sparklyr` extensions
for the [`spark-ts`](https://github.com/srussell91/SparkTS) framework
which was modified from the
[`spark-timeseries`](https://github.com/sryza/spark-timeseries)
framework.

## Installation

You can install sparkts from github with:

``` r
# install.packages("devtools")
devtools::install_github("nathaneastwood/sparkts")
```

## Example

This is a basic example which shows you how to calculate the standard
error for some time series data:

``` r
# Set up a spark connection
sc <- sparklyr::spark_connect(master = "local", version = "2.1.0")

# Extract some data
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
p <- sdf_standard_error$new(sc = sc, data = std_data)

# Calculate the standard errors
p$standard_error(
  x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
  new_column_name = "test"
)
# A tibble: 8 x 5
  ref       xColumn yColumn zColumn  test
  <chr>     <chr>     <dbl>   <dbl> <dbl>
1 000000000 200         120    10.0  10.6
2 111111111 300         220    20.0  14.1
3 222222222 400         320    30.0  16.8
4 333333333 500         420    40.0  19.1
5 444444444 600         520    53.0  22.4
6 555555555 700         620    60.0  22.9
7 666666666 800         720    70.0  24.6
8 777777777 900         820    80.0  26.2

sparklyr::spark_disconnect(sc = sc)
```
