% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sdf_lag.R
\name{sdf_lag}
\alias{sdf_lag}
\title{Calculate lag}
\usage{
sdf_lag(sc, data, partition_cols, order_cols, target_col, lag_num)
}
\arguments{
\item{sc}{A \code{spark_connection}.}

\item{data}{A \code{jobj}: the Spark \code{DataFrame} on which to perform the
function.}

\item{partition_cols}{c(String). A vector of column(s) to partition on.}

\item{order_cols}{c(String). A vector of column(s) to order on.}

\item{target_col}{String. Column name to create a window over.}

\item{lag_num}{Integer. The number of rows back from the current row from
which to obtain a value.}
}
\value{
Returns a \code{jobj}
}
\description{
Calculate lag
}
\examples{
\dontrun{
# Set up a spark connection
sc <- spark_connect(master = "local", version = "2.2.0")

# Extract some data
lag_data <- spark_read_json(
  sc,
  "lag_data",
  path = system.file(
    "data_raw/lag_data.json",
    package = "sparkts"
  )
) \%>\%
  spark_dataframe()

# Call the method
p <- sdf_lag(
  sc = sc, data = lag_data, partition_cols = "id", order_cols = "t",
  target_col = "v", lag_num = 2L
)

# Return the data to R
p \%>\% dplyr::collect()

spark_disconnect(sc = sc)
}

}
