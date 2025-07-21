
#'
#' @imports duckdb duckdb
#' @imports here here

get_ccdm_connection <- function() {



    drv <- duckdb::duckdb(here::here("Data/ccdm.db"))

    conn <- dbConnect(drv)

    conn
}
