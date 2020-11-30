# library(shiny)
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
con = DBI::dbConnect(RSQLite::SQLite(), dbname = "db.sqlite")

# pairing table
init_pairs = data.frame(
  gifter = OFFICEMATES,
  receiver = sample(OFFICEMATES, length(OFFICEMATES))
)

# wishlist table
init_wishlist = data.frame(
  receiver = OFFICEMATES,
  wishlist = rep("Nothing here yet", length(OFFICEMATES))
)

# Write these init tables
shinymanager::write_db_encrypt(con, value = init_pairs, name = "pairs", passphrase = DB_PASSPHRASE)
shinymanager::write_db_encrypt(con, value = init_wishlist, name = "wishlist", passphrase = DB_PASSPHRASE)
