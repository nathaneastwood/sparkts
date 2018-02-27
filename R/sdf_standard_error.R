#' Calculate the standard error
#'
#' This function will add an extra column on to a Spark DataFrame containing the
#' standard error.
#'
#' @param sc A \code{spark_connection}.
#' @param data The Spark \code{DataFrame} on which to perform the function.
#' @param x_col The column to be used as X in the calculation.
#' @param y_col The column to be used as Y in the calculation.
#' @param z_col The column to be used as Z in the calculation.
#' @param new_column_name The name of the standard error column.
#'
#' @examples
#' # Set up a spark connection
#' sc <- sparklyr::spark_connect(master = "local", version = "2.1.0")
#'
#' # Extract some data
#' std_data <- sparklyr::spark_read_json(
#'   sc,
#'   "std_data",
#'   path = system.file(
#'     "data_raw/StandardErrorDataIn.json",
#'     package = "sparkts"
#'   )
#' ) %>%
#'   sparklyr::spark_dataframe()
#'
#' # Calculate the standard error
#' output <- sdf_standard_error(
#'   sc,
#'   std_data,
#'   x_col = "xColumn",
#'   y_col = "yColumn",
#'   z_col = "zColumn",
#'   new_column_name = "stdError"
#' )
#'
#' # Extract the standard error column
#' output <- output %>% dplyr::collect()
#' output[["stdError"]]
#'
#' sparklyr::spark_disconnect(sc = sc)
#'
#' @importFrom sparklyr invoke_static invoke
#' @importFrom dplyr collect %>%
#'
#' @export
sdf_standard_error <- function(
  sc, data, x_col, y_col, z_col, new_column_name
) {

  invoke_static(
    sc,
    class = "com.ons.sml.businessMethods.methods.StandardError",
    method = "standardError",
    df = data
  ) %>%
    invoke(
      method = "stdErr1",
      df = data,
      xCol = x_col,
      yCol = y_col,
      zCol = z_col,
      newColName = new_column_name
    )

}

#' Calculate the standard error
#'
#' This function will add an extra column on to a Spark DataFrame containing the
#' standard error.
#'
#' @section Usage:
#' \preformatted{
#'   p <- sdf_standard_error_r6$new(sc = sc, data = std_data)
#'   p$standard_error(
#'     x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
#'     new_column_name = "test"
#'   )
#' }
#'
#' @section Arguments:
#' \describe{
#'   \item{p}{A \code{waterflow} object.}
#'   \item{wall}{A numeric vector of wall heights}
#' }
#'
#' @section Details:
#' \code{$new()} instantiates the class.
#'
#' \code{$standard_error()} calculates the standard error and returns a
#'   \code{data.frame}.
#'
#' @importFrom R6 R6Class
#'
#' @name sdf_standard_error_r6
#' @examples
#' # Set up a spark connection
#' sc <- sparklyr::spark_connect(master = "local", version = "2.1.0")
#'
#' # Extract some data
#' std_data <- sparklyr::spark_read_json(
#'   sc,
#'   "std_data",
#'   path = system.file(
#'     "data_raw/StandardErrorDataIn.json",
#'     package = "sparkts"
#'   )
#' ) %>%
#'   sparklyr::spark_dataframe()
#'
#' # Instantiate the class
#' p <- sdf_standard_error_r6(sc = sc, data = std_data)
#' # Calculate the standard errors
#' p$standard_error(
#'   x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
#'   new_column_name = "test"
#' )
NULL

#' @export
sdf_standard_error_r6 <- R6::R6Class(
  "sdf_standard_error",
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
