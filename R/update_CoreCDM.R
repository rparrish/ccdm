

#' update_CoreCDM.R
#'
#' updates the CoreCDM tables with new/changed data
#'
#' @param conn a DBI-compliant connection object


update_CoreCDM <- function(conn) {

    #role = "PHC_ANALYTICS"

    sql_files <- fs::path_real(fs::dir_ls(here::here("SQL"), regexp = "update_")) |>
        fs::path_filter(regexp = "99", invert = TRUE) # exclude any .SQL files with "99" in the name

    update_tables <- function(.data, quiet = TRUE ) {

        start_time <- Sys.time()
        #sql_filename <- .data

        sql_filename <- fs::path_file(.data) |>
            fs::path_ext_remove() |>
            stringr::str_replace("^update_[0-9]{2}_", "")

        logger::log_info("updating {sql_filename}...")

        #results <- system2("/home/p348411/bin/snowsql", glue("-r {role} -f {.data} -o quiet={quiet} -w REGIONAL_ANALYTICS_WH_L"), wait = TRUE)
        sql <- read_sql(.data)

        results <- DBI::dbExecute(conn, sql)

        end_time <- Sys.time()

        elapsed <- as.numeric(end_time - start_time)


        if(results > 0) {
            cli::cli_alert_success( "  ... {sql_filename} updated in {prettyunits::pretty_sec(elapsed)}")
        } else {
            cli::cli_alert_danger( "Error with {sql_filename}")
        }
    }

    # run the files through the update_tables function
    updated_files <-
        sql_files |>
        purrr::walk(~update_tables(.x)) |>
        fs::path_file()

}

