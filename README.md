
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sparkts

[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/sparkts)](http://cran.r-project.org/package=sparkts)
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

For details on how to set up for further developing the package, please
see the development vignette.

## Example

This is a basic example which shows you how to calculate the standard
error for some time series data:

``` r
library(sparkts)

# Set up a spark connection
sc <- sparklyr::spark_connect(
  master = "local",
  version = "2.2.0",
  config = list(sparklyr.gateway.address = "127.0.0.1")
)

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
