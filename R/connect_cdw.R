#' Set up  a connection to Cloud Data Warehouse (CDW)
#'
#' ie. Snowflake, Synapse, etc.
#'
#'
#' @param database a valid database that the specified role can access. Default is PHC_DB_DEV
#' @param schema a valid schema that the specified role can access. Default is WHS_CORE_CDM
#' @param quiet Default FALSE. if TRUE, then hide the display of the role, database, default table, and warehouse
#'
#' @importFrom odbc odbc
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' conn <- connect_cdw()
#'
#' ccdm_tbl(conn)
#'
#' ccdm_tbl(conn, "HOSPITAL_ENCOUNTERS")
#'
#' disconnect_cdw(conn)
#' }



connect_cdw<- function(dsn = "CDW",
                       #config = NULL
                       quiet = TRUE
                       ) {

    # show connection settings if called in console
    if(interactive() & quiet == FALSE) {
        cat(glue::glue("
Default schema: {database}.{schema}
Role: {role}
Warehouse: {warehouse}

"))
    }

    # if Linux then use standard connection settings

    # if windows, then use DSN
    DBI::dbConnect(
        drv = odbc::odbc(),
        dsn = "CDW")
}



