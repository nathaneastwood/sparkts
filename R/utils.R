utils <- R6::R6Class(
  "utils",
  private = list(
    collect = function(data) {
      dplyr::collect(data)
    }
  )
)

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

scala_list <- function(sc, x) {
  scala_seq(sc, x) %>%
    invoke("toList")
}
