spark_dependencies <- function(spark_version, scala_version, ...) {
  sparklyr::spark_dependency(
    jars = c(
     system.file(
       "java/sparkts-0.4.0-SNAPSHOT-jar-with-dependencies.jar",
       package = "sparkts"
     )
    ),
    packages = c(
    )
  )
}

#' @import sparklyr
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
