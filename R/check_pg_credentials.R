# Check credentials function that uses the Postgresql connection
check_pg_credentials = function(db_path, passphrase = NULL) {

  # Connect to database
  pg = httr::parse_url(db_path)
  conn <- DBI::dbConnect(
    drv = RPostgres::Postgres(),
    dbname = trimws(pg$path),
    host = pg$hostname,
    port = pg$port,
    user = pg$username,
    password = pg$password,
    sslmode = "require"
  )
  on.exit(DBI::dbDisconnect(conn))

  db = shinymanager::read_db_decrypt(conn = conn, name = "credentials", passphrase = passphrase)
  function(user, password) {
    shinymanager:::check_credentials_df(user, password, credentials_df = db)
  }

}
