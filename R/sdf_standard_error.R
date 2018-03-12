#' Calculate the standard error
#'
#' This function will add an extra column on to a Spark DataFrame containing the
#' standard error.
#'
#' @param sc A \code{spark_connection}.
#' @param data A \code{jobj}: the Spark \code{DataFrame} on which to perform the
#'   function.
#' @param x_col A string. The column to be used as X in the calculation.
#' @param y_col A string. The column to be used as Y in the calculation.
#' @param z_col A string. The column to be used as Z in the calculation.
#' @param new_column_name A string. This is what the standard error column is
#'   called, it can be defaulted to "StandardError".
#'
#' @return Returns a \code{jobj}.
#'
#' @examples
#' \dontrun{
#' # Set up a spark connection
#' sc <- spark_connect(master = "local", version = "2.2.0")
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
#' # Call the method
#' p <- sdf_standard_error(
#'   sc, std_data, x_col = "xColumn", y_col = "yColumn", z_col = "zColumn",
#'   new_column_name = "StandardError"
#' )
#'
#' # Return the data to R
#' p %>% dplyr::collect()
#'
#' spark_disconnect(sc = sc)
#' }
#'
#' @export
sdf_standard_error <- function(
  sc, data, x_col, y_col, z_col, new_column_name
) {
  stopifnot(
    inherits(
      sc, c("spark_connection", "spark_shell_connection", "DBIConnection")
    )
  )
  stopifnot(inherits(data, c("spark_jobj", "shell_jobj")))
  stopifnot(is.character(x_col), length(x_col) == 1)
  stopifnot(is.character(y_col), length(y_col) == 1)
  stopifnot(is.character(z_col), length(z_col) == 1)
  stopifnot(is.character(new_column_name), length(new_column_name) == 1)

  invoke_static(
    sc = sc,
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
