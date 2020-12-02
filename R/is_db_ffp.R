# Function to check if tables exist within a database i.e. is it fit for purpose
is_db_ffp = function(db_path, expected_tables = c("credentials", "pairs", "wishlist")) {

  # Defensive check - expected_tables should be a character vector
  if (!all(lapply(expected_tables, is.character))) {
    stop("expected_tables should be a character vector")
  }

  # Form connection and close when done
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

  # Get the database tables and check that all expected tables are present
  db_tables = DBI::dbListTables(conn)
  res = all(expected_tables %in% db_tables)
  return (res)
}
