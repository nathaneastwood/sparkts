#' Calculate lag
#'
#' @param sc A \code{spark_connection}.
#' @param data A \code{jobj}: the Spark \code{DataFrame} on which to perform the
#'   function.
#' @param partition_cols c(String). A vector of column(s) to partition on.
#' @param order_cols c(String). A vector of column(s) to order on.
#' @param target_col String. Column name to create a window over.
#' @param lag_num Integer. The number of rows back from the current row from
#'   which to obtain a value.
#'
#' @return Returns a \code{jobj}
#'
#' @examples
#' \dontrun{
#' # Set up a spark connection
#' sc <- spark_connect(master = "local", version = "2.2.0")
#'
#' # Extract some data
#' lag_data <- spark_read_json(
#'   sc,
#'   "lag_data",
#'   path = system.file(
#'     "data_raw/lag_data.json",
#'     package = "sparkts"
#'   )
#' ) %>%
#'   spark_dataframe()
#'
#' # Call the method
#' p <- sdf_lag(
#'   sc = sc, data = lag_data, partition_cols = "id", order_cols = "t",
#'   target_col = "v", lag_num = 2L
#' )
#'
#' # Return the data to R
#' p %>% dplyr::collect()
#'
#' spark_disconnect(sc = sc)
#' }
#'
#' @export
sdf_lag <- function(sc, data, partition_cols, order_cols, target_col, lag_num) {
  stopifnot(
    inherits(
      sc, c("spark_connection", "spark_shell_connection", "DBIConnection")
    )
  )
  stopifnot(inherits(data, c("spark_jobj", "shell_jobj")))
  stopifnot(is.character(partition_cols))
  stopifnot(is.character(order_cols))
  stopifnot(is.character(target_col), length(target_col) == 1)
  stopifnot(is.integer(lag_num), length(lag_num) == 1)

  invoke_static(
    sc = sc,
    class = "com.ons.sml.businessMethods.methods.Lag",
    method = "lag",
    df = data
  ) %>%
    invoke(
      method = "lagFunc",
      df = data,
      partitionCols = scala_list(sc, partition_cols),
      orderCols = scala_list(sc, order_cols),
      targetCol = target_col,
      lagNum = lag_num
    )
}
