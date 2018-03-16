testthat_spark_connection <- function() {
  version <- Sys.getenv("SPARK_VERSION", unset = "2.2.0")

  if (exists(".testthat_livy_connection", envir = .GlobalEnv)) {
    spark_disconnect_all()
    Sys.sleep(3)
    livy_service_stop()
    remove(".testthat_livy_connection", envir = .GlobalEnv)
  }

  spark_installed <- spark_installed_versions()
  if (nrow(spark_installed[spark_installed$spark == version, ]) == 0) {
    options(sparkinstall.verbose = TRUE)
    spark_install(version)
  }

  expect_gt(nrow(spark_installed_versions()), 0)

  # generate connection if none yet exists
  connected <- FALSE
  if (exists(".testthat_spark_connection", envir = .GlobalEnv)) {
    sc <- get(".testthat_spark_connection", envir = .GlobalEnv)
    connected <- connection_is_open(sc)
  }

  if (!connected) {
    config <- spark_config()

    options(sparklyr.gateway.address = "127.0.0.1")
    options(sparklyr.sanitize.column.names.verbose = TRUE)
    options(sparklyr.verbose = TRUE)
    options(sparklyr.na.omit.verbose = TRUE)
    options(sparklyr.na.action.verbose = TRUE)

    setwd(tempdir())
    sc <- spark_connect(master = "local", version = version, config = config)
    assign(".testthat_spark_connection", sc, envir = .GlobalEnv)
  }

  # retrieve spark connection
  get(".testthat_spark_connection", envir = .GlobalEnv)
}

#' @param path Folder in which to place the output.
#' @param test_number String. The test number.
#' @param name The function name.
#' @param output The test function's actual output.
#' @param expected The test functions's expected output.
#' @param append logical. If \code{TRUE}, output will be appended to file;
#'   otherwise, it will overwrite the contents of file.
send_output <- function(file,
                        name,
                        output,
                        expected,
                        append = FALSE) {

  sink(file = file, append = append)
  cat(paste0("\n ", name, " :: Actual dataframe out\n"))
  print(output, n = Inf, width = Inf)
  cat(paste0("\n ", name, " :: Expected dataframe out\n"))
  print(expected, n = Inf, width = Inf)
  sink()
}
