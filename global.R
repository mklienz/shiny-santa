library(shiny)
library(shinydashboard)
library(shinymanager)
library(DBI)
library(tibble)

to_title_case = function(x) {
  x = tolower(x)
  substr(x, 1, 1) = toupper(substr(x, 1, 1))
  return(x)
}

if (Sys.getenv("DB_PASSPHRASE") == "") {
  DB_PASSPHRASE = "my_custom_pass"
} else {
  DB_PASSPHRASE = Sys.getenv("DB_PASSPHRASE")
}

# TODO: Check for db.sqlite, if it's not there then stop from running

# Form DB connection
con = DBI::dbConnect(RSQLite::SQLite(), dbname = "db.sqlite")
