
# ccdm

<!-- badges: start -->
<!-- badges: end -->

The goal of ccdm is to ...

The following functionality is provided:

- simplified connections to a specified Cloud Data Warehouse (CDW) or other database server
- de-normalized views supporting OLAP analysis
- shortened syntax for configuring remote pointers to those views and CDW tables
- miscellaneous helper functions

## Installation

You can install the development version of ccdm from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rparrish/ccdm")
```

## Assumptions/dependencies

This package assumes that:

-   you have access to underlying tables and view a CDW or similar database
-   you are somewhat familiar with DBI and the[tidyverse style of working with
    remote database tables](https://db.rstudio.com/dplyr/).
