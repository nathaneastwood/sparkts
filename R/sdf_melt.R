#' Call the melt method
#'
#' This method will take a sequence of column names (strings) and unpivots them
#' into two columns, the "variable_name" and its values.
#'
#' @param sc A \code{spark_connection}.
#' @param data A \code{jobj}: the Spark \code{DataFrame} on which to perform the
#'   function.
#' @param id_variables list(string). Column(s) which are used as unique
#'   identifiers.
#' @param value_variables list(string). Column(s) which are being unpivoted.
#' @param variable_name c(string). The name of a new column, which holds all
#'   the \code{value_variables} names, defaulted to "variable".
#' @param value_name c(string). The name of a new column, which holds all the
#'   values of \code{value_variables} column(s). Defaults to "value".
#'
#' @return Returns a \code{jobj}
#'
#' @examples
#' \dontrun{
#' # Set up a spark connection
#' sc <- spark_connect(master = "local", version = "2.2.0")
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
#' # Call the method
#' p <- sdf_melt(
#'   sc = sc, data = melt_data, id_variables = c("identifier", "date"),
#'   value_variables = c("two", "one", "three", "four"),
#'   variable_name = "variable", value_name = "turnover"
#' )
#'
#' #' # Return the data to R
#' p %>% dplyr::collect()
#'
#' spark_disconnect(sc = sc)
#' }
#'
#' @export
sdf_melt <- function(
  sc, data, id_variables, value_variables, variable_name, value_name
) {
  stopifnot(
    inherits(
      sc, c("spark_connection", "spark_shell_connection", "DBIConnection")
    )
  )
  stopifnot(inherits(data, c("spark_jobj", "shell_jobj")))
  stopifnot(is.character(id_variables))
  stopifnot(is.character(value_variables))
  stopifnot(is.character(variable_name), length(variable_name) == 1)
  stopifnot(is.character(value_name), length(value_name) == 1)

  invoke_static(
    sc = sc,
    class = "com.ons.sml.businessMethods.methods.Melt",
    method = "melt",
    df = data
  ) %>%
    invoke(
      method = "melt1",
      dfIn = data,
      id_vars = scala_seq(sc, id_variables),
      value_vars = scala_seq(sc, value_variables),
      var_name = variable_name,
      value_name = value_name
    )
}
