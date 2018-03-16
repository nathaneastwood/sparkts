#' This method will flag any duplicate records
#'
#' This method adds a column to a dataframe containing duplicate markers.
#'
#' @param sc A \code{spark_connection}.
#' @param data A \code{jobj}: the Spark \code{DataFrame} on which to perform the
#'   function.
#' @param part_col String(s). A vector of the column(s) to check for duplicates
#'   within.
#' @param ord_col String(s). A list of the column(s) to order by.
#' @param new_column_name A string. This is what the duplicate marker column is
#'   called, it can be defaulted to "duplicate".
#'
#' @return
#' Returns a \code{jobj}.
#' * 0 = Duplicate
#' * 1 = Not a Duplicate
#'
#' @examples
#' \dontrun{
#' # Set up a spark connection
#' sc <- spark_connect(master = "local", version = "2.2.0")
#'
#' # Extract some data
#' dup_data <- spark_read_json(
#'   sc,
#'   "std_data",
#'   path = system.file(
#'     "data_raw/DuplicateDataIn.json",
#'     package = "sparkts"
#'   )
#' ) %>%
#'   spark_dataframe()
#'
#' # Call the method
#' p <- sdf_duplicate_marker(
#'   sc, dup_data, part_col = "order", ord_col = "marker"
#' )
#'
#' # Return the data to R
#' p %>% dplyr::collect()
#'
#' spark_disconnect(sc = sc)
#' }
#'
#' @export
sdf_duplicate_marker <- function(sc,
                                 data,
                                 part_col,
                                 ord_col,
                                 new_column_name = "duplicate") {
  stopifnot(
    inherits(
      sc, c("spark_connection", "spark_shell_connection", "DBIConnection")
    )
  )
  stopifnot(inherits(data, c("spark_jobj", "shell_jobj")))
  stopifnot(is.character(part_col), length(part_col) == 1)
  stopifnot(is.character(ord_col), length(ord_col) == 1)
  stopifnot(is.character(new_column_name), length(new_column_name) == 1)

  invoke_static(
    sc = sc,
    class = "com.ons.sml.businessMethods.methods.Duplicate",
    method = "duplicate",
    df = data
  ) %>%
    invoke(
      method = "dm1",
      df = data,
      partCol = scala_list(sc, part_col),
      ordCol = scala_list(sc, ord_col),
      new_col = new_column_name
    )
}
