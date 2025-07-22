

drv <- duckdb("Data/mimic_iv_demo.db")
conn <- dbConnect(drv)
#conn <- dbConnect(spark_connect(method = "databricks"))

create_view_from_location <- function(
        conn,
        #three_part_name = "mimic_iv_demo.ed.diagnosis",
        location,
        table_comment = "no comment"
         ) {

    catalog <- "mimic_iv_demo"
    schema <- stringr::str_extract(location, "Data/mimic-iv-demo/(.*)/(.*).csv.gz", group = 1)
    table <- stringr::str_extract(location, "Data/mimic-iv-demo/(.*)/(.*).csv.gz", group = 2)

    three_part_name <- glue::glue("{catalog}.{schema}.{table}", .con = conn)

    if (class(conn) == "Spark SQL") {
    using_clause <- glue::glue_sql("
-- USING CLAUSE
USING delta
    ", .con = conn)

    table_clause <- glue::glue_sql("
--TABLE CLAUSE
  COMMENT {table_comment}
", .con = conn)

   sql_statement <- glue::glue_sql("
CREATE OR REPLACE view {three_part_name}
USING delta
{`table_clause`}
AS SELECT * FROM {location}
",
    .con = conn
    )
   }

   if (class(conn) == "duckdb_connection") {
       sql_statement <- glue::glue_sql("
--CREATE OR REPLACE view {three_part_name}
CREATE OR REPLACE view {`schema`}.{`table`}
--CREATE OR REPLACE view {three_part_name}
--CREATE OR REPLACE view {three_part_name}
AS SELECT * FROM {location}
",
   .con = conn)
   }

    ql_statement <- glue::glue_sql("
CREATE SCHEMA IF NOT EXISTS ed", .con = conn)


   result <- tryCatch({
       #dbExecute(conn, glue::glue_sql("USE mimic_iv_demo;", .con = conn))
       dbExecute(conn, glue::glue_sql("CREATE SCHEMA IF NOT EXISTS {schema}", .con = conn))
       dbExecute(conn, sql_statement)
    },
    error = function(e) {
        #cli::cli_alert_danger(e$message)
        conditionMessage(e)
        return(e$message)
        },
    finally = {
        #return(cli::cli_alert_success("SCHEMA {schema} created"))
        return(cli::cli_alert_success("{three_part_name} VIEW created"))
    })

    results <- list()

    results$conn <- class(conn)
    results$catalog <- catalog
    results$schema <- schema
    results$table <- table
    results$three_part_name <- three_part_name
    results$sql_statement <- sql_statement
    results$result <- result

     results

}

create_view_from_location(conn, location = "Data/mimic-iv-demo/ed/triage.csv.gz")


file_paths <- fs::dir_ls("Data/mimic-iv-demo/", regexp = "(ed|hosp|icu)/.*.csv.gz", recurse = 1)

file_paths |>
    purrr::walk(~create_view_from_location(conn, .))

tbl(conn, I("mimic_iv_demo.ed.triage"))

dbGetQuery(conn, "FROM duckdb_logs")
dbExecute(conn, "DROP SCHEMA ed CASCADE")
dbGetQuery(conn, "FROM information_schema.schemata")
dbGetQuery(conn, "SELECT
table_catalog, table_schema, table_name
           FROM information_schema.views WHERE table_catalog = 'mimic_iv_demo'
           AND table_schema != 'main'")

#dbExecute(conn, glue::glue_sql("CREATE SCHEMA IF NOT EXISTS ed", .con = conn))

duckdb_shutdown(drv)
dbDisconnect(conn)

