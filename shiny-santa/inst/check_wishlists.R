pkgload::load_all("shiny-santa")

DB_PASSPHRASE = get_default_env_var("DB_PASSPHRASE", "my_custom_pass")
DB_PATH = Sys.getenv("DATABASE_URL")

check_wishlists(DB_PATH, DB_PASSPHRASE)
