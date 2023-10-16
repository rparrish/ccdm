
#' Create a tbl pointer to Canoodle.
#'
#' If a name is not provided, will print a list of the available views in MY_DB.STG_CANOODLE.
#'
#' @param conn a DBI-compliant connection object. recommend using the 'connect_cdw()` function
#' @param name A character string specifying a table in the MY_DB.STG_CANOODLE schema
#'
#' @return  a tbl or a display of tables and views in the STG_CANOODLE schema
#'
#' @importFrom dplyr tbl
#' @importFrom dbplyr in_schema sql
#' @importFrom DBI dbListTables
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' conn <- connect_cdw()
#'
#' canoodle_tbl(conn)
#'
#' canoodle_tbl(conn, "ICU_STAY_DATAMART")
#'
#' disconnect_cdw(conn)
#' }


canoodle_tbl <- function(conn, name = NA) {

    # Todo: check that there's a valid connection
    if(is.na(name)) {
        paste0("View not specified.\nHere's a list of available Canoodle tables:\n\n")

        results <-
            DBI::dbGetQuery(conn, "SELECT * FROM MY_DB.INFORMATION_SCHEMA.TABLES;") %>%
            dplyr::filter(TABLE_SCHEMA == "STG_CANOODLE") %>%
            dplyr::filter(TABLE_TYPE == "BASE TABLE") %>%
            dplyr::mutate(SIZE = prettyunits::pretty_bytes(BYTES)) %>%
            dplyr::mutate(COMMENT = stringr::str_trunc(COMMENT, 80)) %>%
            dplyr::filter(!is.na(TABLE_OWNER)) %>%
            dplyr::select(TABLE_NAME, TABLE_TYPE, ROW_COUNT, SIZE, LAST_ALTERED, COMMENT)

        return(results)

    }

    # get the tbl
    dplyr::tbl(conn, dbplyr::in_schema(sql("MY_DB.STG_CANOODLE"), name))

}

