---
title: "notes"
output: github_document
---

# Introduction

This document is a brain dump of things to consider.

# Jar Versioning

* CDAP uses Spark 1.6.0
* Cloudera Data Science Workbench uses Spark 2.

We need to ensure that the Jar we register with the `sparkts` package is built using the relevant version of Spark. There are different ways we could do this:

1. Have different versions of the R package with different Jars; highly wasteful.
2. Include both Jars in the `dependencies.R` file, then have some code that checks which system the user is on and therefore choose the correct Jar to register

# Testing

* Should the tests be using `master = "local"`? Probably not since the packages will be running on Cloudera Data Science Workbench and CDAP. 
* We should run tests for each version of Spark to ensure the results are what we expect.
