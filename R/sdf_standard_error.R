#' Calculate the standard error
#'
#' This function will add an extra column on to a Spark DataFrame containing the
#' standard error.
#'
#' @section Usage:
#' \preformatted{
#'   p <- sdf_standard_error$new(sc, data)
#'   p$standard_error(data = NULL, x_col, y_col, z_col, new_column_name)
#' }
#'
#' @section Arguments:
#' \describe{
#'   \item{p}{An \code{sdf_standard_error} object.}
#'   \item{x_col}{A string. The column to be used as X in the calculation.}
#'   \item{y_col}{A string. The column to be used as Y in the calculation.}
#'   \item{z_col}{A string. The column to be used as Z in the calculation.}
#'   \item{new_column_name}{A string. This is what the standard error column is
#'     called, it can be defaulted to "StandardError".}
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
#' p <- sdf_standard_error$new(sc = sc, data = std_data)
#' # Calculate the standard errors
#' p$standard_error(
#'   x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
#'   new_column_name = "test"
#' )
#'
#' @name sdf_standard_error
#'
#' @export
NULL

#' @importFrom R6 R6Class
sdf_standard_error <- R6::R6Class(
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
