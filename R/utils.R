utils <- R6::R6Class(
  "utils",
  private = list(
    collect = function(data) {
      dplyr::collect(data)
    }
  )
)
