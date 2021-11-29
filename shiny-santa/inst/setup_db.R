pkgload::load_all("shiny-santa")

OFFICEMATES = c(
  "Your office mates here"
)

DB_PASSPHRASE = get_default_env_var("DB_PASSPHRASE", "my_custom_pass")
DB_PATH = Sys.getenv("DATABASE_URL")

set.seed(Sys.time())

reset_db(
  db_path = DB_PATH,
  db_passphrase = DB_PASSPHRASE,
  people = OFFICEMATES,
  admin = "matt"
)
