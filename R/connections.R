
#'
#' @imports duckdb duckdb
#' @imports here here

get_ccdm_connection <- function() {

    conn <- duckdb::duckdb()

    if(!config::get()$environment == "local") {

    drv <- duckdb::duckdb(here::here("Data/ccdm.db"))
    conn <- dbConnect(drv)

    }

    if(config::get()$environment == "local") {

        Sys.setenv(DATABRICKS_HOST = "dbc-4600d6a7-5d0e.cloud.databricks.com")

    conn <- dbConnect(
        drv = odbc::databricks(),
        httpPath = "/sql/1.0/warehouses/9f70acd8ebe5803f",
        uid = "token",
        pwd = "my_token",
        catalog = "metastore"
        )
    }


    conn
}
