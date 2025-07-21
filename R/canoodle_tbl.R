
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

        table_info <-
            DBI::dbGetQuery(conn, "SELECT * FROM metastore.INFORMATION_SCHEMA.TABLES;") %>%
            #dplyr::filter(table_schema == "mimic_iv_demo") %>%
            dplyr::filter(table_type == "MANAGED") %>%
            #dplyr::mutate(size = prettyunits::pretty_bytes(bytes)) %>%
            dplyr::mutate(comment = stringr::str_trunc(comment, 80)) %>%
            dplyr::mutate(name = glue::glue("metastore.{table_schema}.{table_name}",
                          .con = conn)) %>%
            #dplyr::filter(!is.na(table_owner)) %>%
            dplyr::select(
                name,
                table_schema, table_name, table_type,
                          #row_count, size,
                          last_altered, comment)

        table_details <-
            DBI::dbGetQuery(conn, "DESCRIBE DETAIL metastore.ccdm.lab") %>%
            dplyr::mutate(size = prettyunits::pretty_bytes(sizeInBytes, "6")) %>%
            dplyr::select(name, size)

        results <-
            table_info %>%
            inner_join(table_details, join_by(name)) %>%
            select(name, size, last_altered, comment)

        return(results)

    }

    # get the tbl
    dplyr::tbl(conn, in_catalog("metastore", "ccdm", name))

}

