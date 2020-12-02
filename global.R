library(shiny)
library(shinydashboard)
library(shinymanager)
library(DBI)
library(tibble)

source("./R/utils.R")

# Set up env vars
DB_PASSPHRASE = get_default_env_var("DB_PASSPHRASE", "my_custom_pass")
DB_PATH = get_default_env_var("DB_PATH", "db.sqlite")

# TODO: Check for db.sqlite, if it's not there then stop from running
if (!file.exists(DB_PATH)) {
  message("No db found; making a new one")
  source(file.path("inst", "init_db.R"))
}

# Form DB connection
con = DBI::dbConnect(RSQLite::SQLite(), dbname = DB_PATH)
