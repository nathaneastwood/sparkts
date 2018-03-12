#' Generate a Scala Seq
#'
#' Scala Seq (sequence) cannot be generated using sparklyr. We must generate
#' them using this function.
#'
#' @param sc A \code{spark_connection}.
#' @param x A vector.
#'
#' @examples
#' \dontrun{
#' sc <- sparklyr::spark_connect(master = "local", version = "2.2.0")
#' sparkts:::scala_seq(sc, c(1, 2, 3))
#' sparklyr::spark_disconnect(sc = sc)
#' }
scala_seq <- function(sc, x) {
  al <- invoke_new(sc, "java.util.ArrayList")
  lapply(
    x,
    FUN = function(y) {
      invoke(al, "add", y)
    }
  )
  invoke_static(sc, "scala.collection.JavaConversions", "asScalaBuffer", al) %>%
    invoke("toSeq")
}

#' Generate a Scala List
#'
#' Scala List cannot be generated using sparklyr. We must generate them using
#' this function.
#'
#' @param sc A \code{spark_connection}.
#' @param x A vector.
#'
#' @examples
#' \dontrun{
#' sc <- sparklyr::spark_connect(master = "local", version = "2.2.0")
#' sparkts:::scala_list(sc, c(1, 2, 3))
#' sparklyr::spark_disconnect(sc = sc)
#' }
scala_list <- function(sc, x) {
  scala_seq(sc, x) %>%
    invoke("toList")
}
