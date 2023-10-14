
#'
#' @imports duckdb duckdb
#' @imports here here

get_ccdm_connection <- function() {

    conn <- duckdb::duckdb(here::here("Data/ccdm.db"))

    conn
}
