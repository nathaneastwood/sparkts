#' Calculate lag
#'
#' @section Usage:
#' \preformatted{
#'   p <- sdf_lag$new(sc, data)
#'   p$lag(
#'     data = NULL, partition_cols, order_cols, target_col, lag_num
#'   )
#' }
#'
#' @section Arguments:
#' \describe{
#'   \item{p}{An \code{sdf_melt} object.}
#'   \item{sc}{A \code{spark_connection}.}
#'   \item{data}{The Spark \code{DataFrame} on which to perform the function.}
#'   \item{partition_cols}{c(String). A vector of column(s) to partition on.}
#'   \item{order_cols}{c(String). A vector of column(s) to order on.}
#'   \item{target_col}{String. Column name to create a window over.}
#'   \item{lag_num}{Integer. The number of rows back from the current row from
#'     which to obtain a value.}
#' }
#'
#' @section Details:
#' \code{$new()} instantiates the class.
#'
#' \code{$lag()} calls the lag function.
#'
#' @return A \code{data.frame}.
#'
#' @examples
#' # Set up a spark connection
#' sc <- sparklyr::spark_connect(master = "local", version = "2.1.0")
#'
#' # Extract some data
#' lag_data <- sparklyr::spark_read_json(
#'   sc,
#'   "lag_data",
#'   path = system.file(
#'     "data_raw/lag_data.json",
#'     package = "sparkts"
#'   )
#' ) %>%
#'   sparklyr::spark_dataframe()
#'
#' # Instantiate the class
#' p <- sdf_lag$new(sc = sc, data = lag_data)
#'
#' # Calculate the lag
#' p$lag(
#'   partition_cols = "id",
#'   order_cols = "t",
#'   target_col = "v",
#'   lag_num = 2L
#' )
#'
#' sparklyr::spark_disconnect(sc = sc)
#'
#' @name sdf_lag
#'
#' @export
NULL

#' @importFrom R6 R6Class
#' @importFrom sparklyr invoke_static invoke
sdf_lag <- R6::R6Class(
  "sdf_lag",
  inherit = utils,
  public = list(
    sc = NULL,
    data = NULL,
    initialize = function(sc, data) {
      self$sc <- sc
      self$data <- data
      init <- invoke_static(
        sc = self$sc,
        class = "com.ons.sml.businessMethods.methods.Lag",
        method = "lag",
        df = self$data
      )
      private$init <- init
    },
    lag = function(
      data = NULL, partition_cols, order_cols, target_col, lag_num
    ) {
      private$init %>%
        invoke(
          method = "lagFunc",
          df = data,
          partitionCols = scala_list(self$sc, partition_cols),
          orderCols = scala_list(self$sc, order_cols),
          targetCol = target_col,
          lagNum = lag_num
        ) %>%
        private$collect()
    }
  ),
  private = list(
    init = NULL
  )
)

