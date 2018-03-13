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
sdf_duplicate_marker <- function(sc, data, partcol, ordcol, new_col1) {
  stopifnot(
    inherits(
      sc, c("spark_connection", "spark_shell_connection", "DBIConnection")
    )
  )
  stopifnot(inherits(data, c("spark_jobj", "shell_jobj")))
  stopifnot(is.character(partcol), length(partcol) == 1)
  stopifnot(is.character(ordcol), length(ordcol) == 1)
  stopifnot(is.character(new_col1), length(new_col1) == 1)

  invoke_static(
    sc = sc,
    class = "com.ons.sml.businessMethods.methods.Duplicate",
    method = "duplicate",
    df = data
  ) %>%
    invoke(
      method = "dm1",
      df = data,
      partCol = scala_list(sc, partcol),
      ordCol = scala_list(sc, ordcol),
      new_col = new_col1
    )
}
