# This function is largely stolen from shinymanager
# but modified to use a Postgresql connection instead
# Sections where code has been changed from original is marked.
check_pg_db = function (credentials_data,
                        db_path,
                        passphrase = NULL)
{
  if (!all(c("user", "password") %in% names(credentials_data))) {
    stop("credentials_data must contains columns: 'user', 'password'",
         call. = FALSE)
  }
  if (any(duplicated(credentials_data$user))) {
    stop("Duplicated users in credentials_data", call. = FALSE)
  }
  if (!"admin" %in% names(credentials_data)) {
    credentials_data$admin <- FALSE
  }
  if (!"start" %in% names(credentials_data)) {
    credentials_data$start <- NA
  }
  if (!"expire" %in% names(credentials_data)) {
    credentials_data$expire <- NA
  }
  default_col <- c("user", "password", "start", "expire",
                   "admin")
  credentials_data <-
    credentials_data[, c(default_col, setdiff(colnames(credentials_data),
                                              default_col))]

  # Change connection from SQLite into Postgres
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

  credentials_data[] <- lapply(credentials_data, as.character)
  shinymanager::write_db_encrypt(
    conn = conn,
    name = "credentials",
    value = credentials_data,
    passphrase = passphrase
  )
  shinymanager::write_db_encrypt(
    conn = conn,
    name = "pwd_mngt",
    value = data.frame(
      user = credentials_data$user,
      must_change = as.character(FALSE),
      have_changed = as.character(FALSE),
      date_change = character(length(credentials_data$user)),
      stringsAsFactors = FALSE
    ),
    passphrase = passphrase
  )
  shinymanager::write_db_encrypt(
    conn = conn,
    name = "logs",
    value = data.frame(
      user = character(0),
      server_connected = character(0),
      token = character(0),
      logout = character(0),
      app = character(0),
      stringsAsFactors = FALSE
    ),
    passphrase = passphrase
  )
}
