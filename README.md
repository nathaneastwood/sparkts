
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

The goal of `sparkts` is to provide a test bed of `sparklyr` extensions
for the [`spark-ts`](https://github.com/srussell91/SparkTS) framework
which was modified from the
[`spark-timeseries`](https://github.com/sryza/spark-timeseries)
framework.

## Installation

You can install `sparkts` from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("nathaneastwood/sparkts")
```

If you have cloned `sparkts` and wish to `build` it, you will need:

  - R (\>= 3.4.3)
  - RStudio
  - RTools34

You will then need to run the following commands (note we need the
development version of `sparklyr` due to bugs in the version available
from CRAN):

``` r
install.packages(c("dplyr", "R6", "devtools", "testthat", "covr"))
devtools::install_github("rstudio/sparklyr")
sparklyr::install_spark(version = "2.2.0")
```

Then opening the `sparkts.Rproj` file will give you access to the Build
tab from which you can “Install and Restart” (or Ctrl + Shift + B for
windows or Cmd + Shift + B for Mac). This will build the package,
install it, retart R and load the package.

## Example

This is a basic example which shows you how to calculate the standard
error for some time series data:

``` r
library(sparkts)

# Set up a spark connection
sc <- spark_connect(master = "local", version = "2.2.0")

# Extract some data
std_data <- spark_read_json(
  sc,
  "std_data",
  path = system.file(
    "data_raw/StandardErrorDataIn.json",
    package = "sparkts"
  )
) %>%
  spark_dataframe()

# Call the method
p <- sdf_standard_error(
  sc = sc, data = std_data,
  x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
  new_column_name = "StandardError"
)

p %>% dplyr::collect()
# # A tibble: 8 x 5
#   ref       xColumn yColumn zColumn StandardError
#   <chr>     <chr>     <dbl>   <dbl>         <dbl>
# 1 000000000 200        120.     10.          10.6
# 2 111111111 300        220.     20.          14.1
# 3 222222222 400        320.     30.          16.8
# 4 333333333 500        420.     40.          19.1
# 5 444444444 600        520.     53.          22.4
# 6 555555555 700        620.     60.          22.9
# 7 666666666 800        720.     70.          24.6
# 8 777777777 900        820.     80.          26.2

# Disconnect from the spark connection
spark_disconnect(sc = sc)
```
