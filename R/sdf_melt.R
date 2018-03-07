#' Call the melt method
#'
#' This method will take a sequence of column names (strings) and unpivots them
#' into two columns, the "variable_name" and its values.
#'
#' @section Usage:
#' \preformatted{
#'   p <- sdf_melt$new(sc, data)
#'   p$melt(
#'     data = NULL, id_variables, value_variables, variable_name, value_name
#'   )
#' }
#'
#' @section Arguments:
#' \describe{
#'   \item{p}{An \code{sdf_melt} object.}
#'   \item{sc}{A \code{spark_connection}.}
#'   \item{data}{The Spark \code{DataFrame} on which to perform the function.}
#'   \item{id_variables}{list(string). Column(s) which are used as unique
#'     identifiers.}
#'   \item{value_variables}{list(string). Column(s) which are being
#'     unpivoted.}
#'   \item{variable_name}{c(string). The name of a new column, which holds all
#'     the \code{value_variables} names, defaulted to "variable".}
#'   \item{value_name}{c(string). The name of a new column, which holds all the
#'     values of \code{value_variables} column(s). Defaults to "value".}
#' }
#'
#' @section Details:
#' \code{$new()} instantiates the class.
#'
#' \code{$melt_1()} calls version 1 of the melt method.
#'
#' @return A \code{data.frame}.
#'
#' @examples
#' # Set up a spark connection
#' sc <- spark_connect(master = "local", version = "2.1.0")
#'
#' # Extract some data
#' melt_data <- spark_read_json(
#'   sc,
#'   "melt_data",
#'   path = system.file(
#'     "data_raw/Melt.json",
#'     package = "sparkts"
#'   )
#' ) %>%
#'   spark_dataframe()
#'
#' # Instantiate the class
#' p <- sdf_melt$new(sc = sc, data = melt_data)
#'
#' # Calculate the standard errors
#' p$melt_1(
#'   id_variables = c("identifier", "date"),
#'   value_variables = c("two", "one", "three", "four"),
#'   variable_name = "variable",
#'   value_name = "turnover"
#' )
#'
#' spark_disconnect(sc = sc)
#'
#' @name sdf_melt
#'
#' @export
NULL

#' @importFrom R6 R6Class
#' @importFrom sparklyr invoke_static invoke
sdf_melt <- R6::R6Class(
  "sdf_melt",
  inherit = utils,
  public = list(
    sc = NULL,
    data = NULL,
    initialize = function(sc, data) {
      self$sc <- sc
      self$data <- data
      init <- invoke_static(
        sc = self$sc,
        class = "com.ons.sml.businessMethods.methods.Melt",
        method = "melt",
        df = self$data
      )
      private$init <- init
    },
    melt_1 = function(
      data = self$data, id_variables, value_variables, variable_name, value_name
    ) {
      private$init %>%
        invoke(
          method = "melt1",
          dfIn = data,
          id_vars = scala_seq(self$sc, id_variables),
          value_vars = scala_seq(self$sc, value_variables),
          var_name = variable_name,
          value_name = value_name
        ) %>%
        private$collect()
    }
  ),
  private = list(
    init = NULL
  )
)
