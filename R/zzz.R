
# The .onLoad and function runs when you
# run library(ccdm), and will create
# your DB accessor functions when the package is loaded.

#' Connect to the ccdm database and create
#' accessor funtions when the package is loaded.
#'
#' Note how the exportPattern below matches the con_id
#' ("lahman") in the call to dbc_init. This will ensure
#' all of your table accessor functions are exported to
#' the package namespace.
#'

.onLoad <- function(libname, pkgname) {
    # Use the internal function to create a db connection (see connections.R)
    con <- get_ccdm_connection()

}

#' Clear connections when the package is unloaded.
#'
.onUnload <- function(libpath){

    DBI::dbDisconnect(con, shutdown = TRUE)
}
