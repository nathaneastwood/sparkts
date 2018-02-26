#' Calculate lag
#'
#' @param sc A \code{spark_connection}.
#' @param data The Spark \code{DataFrame} on which to perform the function.
#' @param partition_cols list(string): List of column(s) to partition on
#' @param order_cols list(string): List of column(s) to order on
#' @param target_col list(string): Column name to create a window over
#' @param lag_num Integer: The number of rows back from the current row from
#'   which to obtain a value
#'
#' @return \code{sql.DataFrame}: The DataFrame returned
#'
#' @examples
#' # Set up a spark connection
#' sc <- sparklyr::spark_connect(master = "local", version = "2.1.0")
#'
#' # Extract some data
#' lag_data <- sparklyr::spark_read_json(
#'   sc,
#'   "std_data",
#'   path = system.file(
#'     "data_raw/lag_data.json",
#'     package = "testsml"
#'   )
#' ) %>%
#'   sparklyr::spark_dataframe()
#'
#' # Calculate the lag
#' output <- sdf_lag(
#'   sc,
#'   data = lag_data,
#'   partition_cols = "id",
#'   order_cols = "t",
#'   target_col = "v",
#'   lag_num = 2L
#' )
#'
#' # Extract the standard error column
#' output <- output %>% dplyr::collect()
#' output
#'
#' sparklyr::spark_disconnect(sc = sc)
#'
#' @importFrom sparklyr invoke_static invoke
#' @importFrom dplyr %>%
#'
#' @export
sdf_lag <- function(
  sc, data, partition_cols, order_cols, target_col, lag_num
) {

  invoke_static(
    sc,
    class = "com.ons.sml.businessMethods.methods.Lag",
    method = "lag",
    df = data
  ) %>%
    invoke(
      method = "lagFunc",
      df = data,
      partitionCols = partition_cols, orderCols = order_cols,
      targetCol = target_col, lagNum = lag_num
    )

}
