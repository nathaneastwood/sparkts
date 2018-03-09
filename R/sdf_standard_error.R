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
#'   \item{sc}{A \code{spark_connection}.}
#'   \item{data}{The Spark \code{DataFrame} on which to perform the function.}
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
#' @return A \code{data.frame}.
#'
#' @examples
#' # Set up a spark connection
#' sc <- spark_connect(master = "local", version = "2.1.0")
#'
#' # Extract some data
#' std_data <- spark_read_json(
#'   sc,
#'   "std_data",
#'   path = system.file(
#'     "data_raw/StandardErrorDataIn.json",
#'     package = "sparkts"
#'   )
#' ) %>%
#'   spark_dataframe()
#'
#' # Instantiate the class
#' p <- sdf_standard_error$new(sc = sc, data = std_data)
#'
#' # Calculate the standard errors
#' p$standard_error(
#'   x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
#'   new_column_name = "StandardError"
#' )
#'
#' spark_disconnect(sc = sc)
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
      stopifnot(
        inherits(
          sc, c("spark_connection", "spark_shell_connection", "DBIConnection")
        )
      )
      stopifnot(
        inherits(
          data, c("spark_jobj", "shell_jobj")
        )
      )
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
      stopifnot(is.character(x_col), length(x_col) == 1)
      stopifnot(is.character(y_col), length(y_col) == 1)
      stopifnot(is.character(z_col), length(z_col) == 1)
      stopifnot(is.character(new_column_name), length(new_column_name) == 1)
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
