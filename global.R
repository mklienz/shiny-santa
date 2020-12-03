library(shiny)
library(shinydashboard)
library(shinymanager)
library(DBI)
library(tibble)

source("./R/utils.R")
source("./R/is_db_ffp.R")
source("./R/init_shiny_santa_db.R")
source("./R/check_pg_db.R")
source("./R/check_pg_credentials.R")
source("./R/update_password.R")

# Set up env vars
DB_PASSPHRASE = get_default_env_var("DB_PASSPHRASE", "my_custom_pass")

if (Sys.getenv("DATABASE_URL") == "") {
  stop("Can't find a database connection")
} else {
  DB_PATH = Sys.getenv("DATABASE_URL")
  # Check if the database is fit for purpose. If not, initalise by running init_db script
  if (!is_db_ffp(db_path = DB_PATH)) {
    message("Database is not fit for purpose; re-initialising")

    OFFICEMATES = c(
      "alex",
      "ari",
      "arvin",
      "glenn",
      "harel",
      "lisa",
      "matt",
      "mia",
      "michael",
      "nick",
      "stacey",
      "travis"
    )

    init_shiny_santa_db(
      db_path = DB_PATH,
      db_passphrase = DB_PASSPHRASE,
      people = OFFICEMATES,
      admin = "matt"
    )
  }
}

pg = httr::parse_url(DB_PATH)
con = DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = trimws(pg$path),
  host = pg$hostname,
  port = pg$port,
  user = pg$username,
  password = pg$password,
  sslmode = "require"
)
