# Function to initialise database for shiny-santa
init_shiny_santa_db = function(db_path,
                               db_passphrase = NULL,
                               people,
                               default_password = "harmonic",
                               default_wishlist = "Nothing here yet",
                               admin = NULL) {

  # Defensive programming - people should be a character vector
  if (!all(sapply(people, is.character, USE.NAMES = FALSE))) {
    stop("people should be a character vector")
  }

  # Set up admin
  if (is.null(admin)) {
    admin = rep(FALSE, length(people))
  } else {
    admin = grepl(admin[1], people)
  }

  base_credentials = tibble::tibble(
    user = people, # Vector of names
    password = rep(default_password, length(people)),
    admin = admin,
    stringsAsFactors = FALSE
  )

  init_pairs = tibble::tibble(
    gifter = sample(people, length(people)),
    receiver = c(gifter[-1], gifter[1])
  )

  init_wishlist = tibble::tibble(
    receiver = people,
    wishlist = rep("Nothing here yet", length(people))
  )

  # Initialise DB with credentials first
  check_pg_db(
    credentials_data = base_credentials,
    db_path = db_path,
    passphrase = db_passphrase
  )

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

  shinymanager::write_db_encrypt(conn,
                                 value = init_pairs,
                                 name = "pairs",
                                 passphrase = db_passphrase)
  shinymanager::write_db_encrypt(conn,
                                 value = init_wishlist,
                                 name = "wishlist",
                                 passphrase = db_passphrase)


}
