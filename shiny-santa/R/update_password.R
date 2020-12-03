update_password = function (user, pwd, db_path, passphrase)
{
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

  res_pwd <- try({
    users <- shinymanager::read_db_decrypt(conn, name = "credentials",
                             passphrase = passphrase)
    ind_user <- users$user %in% user
    if (identical(users$password[ind_user], pwd)) {
      print(users$password[ind_user])
      return(list(result = FALSE))
    }
    if (!"character" %in% class(users$password)) {
      users$password <- as.character(users$password)
    }
    if (!"is_hashed_password" %in% colnames(users)) {
      users$is_hashed_password <- FALSE
    }
    users$password[ind_user] <- pwd
    users$is_hashed_password[ind_user] <- FALSE
    shinymanager::write_db_encrypt(conn, value = users, name = "credentials",
                     passphrase = passphrase)
  }, silent = TRUE)
  return(list(result = !inherits(res_pwd, "try-error")))
}
