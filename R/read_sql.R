#' get the results of a SQL query
#'
#' Reads an .sql file and prepares it for use with dbplyr/odbc queries to SQL Server/Snowflake, etc.
#'
#' The original version of this function was developed by Thomas Huang.
#'
#' @param file_name character string with the path and filename of the .sql file
#'
#' @return concise sql statement ready to be passed to SQL Server/Snowflake, etc.
#' @export
#'
#' @examples
#'
#' \dontrun{
#' sql_statement <- read_sql(here::here("SQL/demo.sql"))
#'
#' # use dbGetQuery for single SQL clauses
#' results <- ccdm_query(sql_statement)
#'
#' # use snowsql for complex SQL statements with multiple clauses
#' results2 <- system2("~/bin/snowsql", glue("-f {sql_statement} -o quiet={quiet}"))
#'
#' }


read_sql = function(file_name) {

    x <- readLines(file_name)

    x <- gsub("\t+", " ", x)        # Replace tabs with spaces
    x <- gsub("^\\s+", "", x)       # Remove leading whitespace from each line
    x <- gsub("\\s+$", "", x)       # Remove trailing whitespace from each line
    x <- gsub("(--)+.*$", "", x)    # Remove inline comments from each line
    x <- x[x != ""]                 # Remove blank lines
    x <- paste(x, collapse = " ")   # Collapse to single line
    x <- gsub("/\\*.*?\\*/", "", x) # Remove multiline comments (cannot be nested)
    x <- gsub("^\\s+", "", x)       # Remove leading whitespace (leftover from multiline comments)
    x <- gsub("[ ]+", " ", x)       # Collapse multiple spaces to a single space

    return(x)

}
