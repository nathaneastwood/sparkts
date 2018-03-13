# Package Development

Developing this package further will require a working knowledge of several packages. Detailed below are several links to books, packages and vignettes.

* Tools to make an R developer's life easier: [devtools](https://github.com/r-lib/devtools)
* Keep your code and code documentation together using [Roxygen2](https://github.com/klutometis/roxygen): Check out the vignettes [here](https://cran.r-project.org/web/packages/roxygen2/)
* Test your code with [testthat](https://github.com/r-lib/testthat)

You can read about these tools and the wider R package development world in the [R Packages](http://r-pkgs.had.co.nz) book.

Key functions to know about are:

* devtools::document()
* devtools::test()
* devtools::check()
* devtools::build()

A very good (free) book on general R can be found [here](https://adv-r.hadley.nz).

All of the packages I have mentioned come from the "[tidyverse](https://www.tidyverse.org)" which is a collection of packages that work very well together. A key package which works well with [sparklyr](http://spark.rstudio.com) is called [dplyr](http://dplyr.tidyverse.org). dplyr provides a grammar of data manipulation, providing a consistent set of verbs that solve the most common data manipulation challenges. It is the package to use for data manipulation in R and is R's version of the Python pandas library.
