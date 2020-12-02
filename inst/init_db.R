library(shiny)
library(shinymanager)

# Setup that doesn't need to go in core shinyapp --------------------------
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

DB_PASSPHRASE = "my_custom_pass"
DB_PATH = "db.sqlite"

base_credentials = data.frame(
  user = OFFICEMATES, # Vector of names
  password = rep("best_harmonic_office", length(OFFICEMATES)),
  admin = grepl("matt", OFFICEMATES),
  stringsAsFactors = FALSE
)

# Init DB
shinymanager::create_db(
  credentials_data = base_credentials,
  sqlite_path = "db.sqlite",
  passphrase = DB_PASSPHRASE
)

# Init DB tables
con = DBI::dbConnect(RSQLite::SQLite(), dbname = DB_PATH)

# pairing table
init_pairs = tibble::tibble(
  gifter = sample(OFFICEMATES, length(OFFICEMATES)),
  receiver = c(gifter[-1], gifter[1])
)

# wishlist table
init_wishlist = tibble::tibble(
  receiver = OFFICEMATES,
  wishlist = rep("Nothing here yet", length(OFFICEMATES))
)

# Write these init tables
shinymanager::write_db_encrypt(con, value = init_pairs, name = "pairs", passphrase = DB_PASSPHRASE)
shinymanager::write_db_encrypt(con, value = init_wishlist, name = "wishlist", passphrase = DB_PASSPHRASE)
