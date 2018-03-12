API Decision
================

# Set up the data

``` r
# Connect to spark
sc <- sparklyr::spark_connect(master = "local", version = "2.2.0")
```

``` r
# Dataset 1
std_data <- sparklyr::spark_read_json(
  sc,
  "std_data",
  path = system.file(
    "data_raw/StandardErrorDataIn.json",
    package = "sparkts"
  )
) %>%
  sparklyr::spark_dataframe()
std_data %>% dplyr::collect()
# # A tibble: 8 x 4
#   ref       xColumn yColumn zColumn
#   <chr>     <chr>     <dbl>   <dbl>
# 1 000000000 200        120.     10.
# 2 111111111 300        220.     20.
# 3 222222222 400        320.     30.
# 4 333333333 500        420.     40.
# 5 444444444 600        520.     53.
# 6 555555555 700        620.     60.
# 7 666666666 800        720.     70.
# 8 777777777 900        820.     80.
```

``` r
# Dataset 2
melt_data <- spark_read_json(
  sc,
  "melt_data",
  path = system.file(
    "data_raw/Melt.json",
    package = "sparkts"
  )
) %>%
  spark_dataframe()
melt_data %>% dplyr::collect()
# # A tibble: 6 x 6
#   date    four identifier   one three   two
#   <chr>  <dbl> <chr>      <dbl> <dbl> <dbl>
# 1 201702   50. qwer         65.   10.   43.
# 2 201701   50. qwer         65.   10.   43.
# 3 201701   50. tyui         34.   20.   23.
# 4 201701   50. opas         23.   30.   33.
# 5 201701   50. dfgh         32.   40.   21.
# 6 201701   50. jklz         41.   50.   19.
```

# Traditional R (S3 / Generics)

Defining the function:

``` r
se_trad <- function(sc, data, x_col, y_col, z_col, new_column_name) {
  # Invoke the function
  invoke_static(
    sc = sc,
    class = "com.ons.sml.businessMethods.methods.StandardError",
    method = "standardError",
    df = data
  ) %>% 
    invoke(
      method = "stdErr1",
      #df = data,
      df = NULL,
      xCol = x_col,
      yCol = y_col,
      zCol = z_col,
      newColName = new_column_name
    )
}
```

Calling the function:

``` r
sdf_se1 <- se_trad(
  sc, std_data, x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
  new_column_name = "StandardError"
)
sdf_se1 %>% dplyr::collect()
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
```

# R6

``` r
utils <- R6::R6Class(
  "utils",
  private = list(
    collect = function(data) {
      dplyr::collect(data)
    }
  )
)

se_r6 <- R6::R6Class(
  "se_r6",
  inherit = utils,
  public = list(
    initialize = function(sc, data) {
      init <- invoke_static(
        sc = sc,
        class = "com.ons.sml.businessMethods.methods.StandardError",
        method = "standardError",
        df = data
      )
      private$init <- init
    },
    standard_error = function(
      data = NULL, x_col, y_col, z_col, new_column_name
    ) {
      private$init %>%
        invoke(
          method = "stdErr1",
          df = data,
          xCol = x_col,
          yCol = y_col,
          zCol = z_col,
          newColName = new_column_name
        ) %>%
        private$collect()
    }
  ),
  private = list(
    init = NULL
  )
)
```

Calling the function:

``` r
# Instantiate the function
p <- se_r6$new(sc = sc, data = std_data)

# Call the standard error method
output <- p$standard_error(
  x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
  new_column_name = "StandardError"
)

output
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
```

We can call this a second time with a new dataset without instantiating
the class again - just like Scala\!

``` r
p$standard_error(
  data = melt_data,
  x_col = "one", y_col = "three", z_col = "two", new_column_name = "new_col"
)
# # A tibble: 6 x 7
#   date    four identifier   one three   two new_col
#   <chr>  <dbl> <chr>      <dbl> <dbl> <dbl>   <dbl>
# 1 201702   50. qwer         65.   10.   43.   271. 
# 2 201701   50. qwer         65.   10.   43.   271. 
# 3 201701   50. tyui         34.   20.   23.    25.7
# 4 201701   50. opas         23.   30.   33.   NaN  
# 5 201701   50. dfgh         32.   40.   21.   NaN  
# 6 201701   50. jklz         41.   50.   19.   NaN
```

We can also use chaining

``` r
se_r6$
  new(sc = sc, data = std_data)$
  standard_error(
    x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
    new_column_name = "StandardError"
  )
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
```

# Pros and Cons

Using generics (or S3) and R6 both have their pros and cons. Here is a
quick look at them. See
[here](https://adv-r.hadley.nz/oo-tradeoffs.html#s3-r6) for more
details.

## Generics

Pros:

  - Simple
  - Widely used
  - Built on generic functions
  - It’s a more traditional way of writing R code
  - Supported by Roxygen

Cons:

  - Different API to Scala

## R6

Pros:

  - Built on encapsulated objects
  - Has references semantics (can be modified in place)

Cons:

  - May feel unfamiliar to R users
  - Not well supported by Roxygen
