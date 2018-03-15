#' Sum_col method
#'
#' This function will perform a function similar to a SQL Group By.
#' It should be noted that it does not perform this identically to what you'd
#' typically expect of an ANSI like SQL statement. A new column is added onto
#' the returning data rather than automatically returning columns parameterised
#' as part of the call. With this function you need to performa an additional
#' select. Also only one SINGLE sum-by column can be used.
#'
#' @param sc A \code{spark_connection}.
#' @param data A \code{jobj}: the Spark \code{DataFrame} on which to perform the
#'   function.
#' @param group_by_cols c(String). A vector of columns to Group-By
#' @param sum_col_name String.A column to Sum-By
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
sdf_sum_col <- function(sc, data, group_by_cols, sum_col_name) {
  stopifnot(
    inherits(
      sc, c("spark_connection", "spark_shell_connection", "DBIConnection")
    )
  )
  stopifnot(inherits(data, c("spark_jobj", "shell_jobj")))
  stopifnot(is.character(group_by_cols))
  stopifnot(is.character(sum_col_name), length(sum_col_name) == 1)

  invoke_static(
    sc = sc,
    class = "com.ons.sml.businessMethods.methods.SumCol",
    method = "sumCol",
    df = data
  ) %>%
    invoke(
      method = "sumCol1",
      df = data,
      groupByCols = scala_list(sc, group_by_cols),
      sumCol = sum_col_name
    )
}
