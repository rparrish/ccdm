
#'
#' @import duckdb

get_ccdm_connection <- function() {

    conn <- duckdb::duckdb()

    conn
}
