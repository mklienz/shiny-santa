server = function(input, output, session) {
  res_auth = shinymanager::secure_server(check_credentials = check_pg_credentials(db_path = DB_PATH,
                                                                                  passphrase = DB_PASSPHRASE))

  user_wishlist = reactiveVal()
  others_wishlist = reactiveVal()

  # Initialise reactive values once authenticated
  observeEvent(res_auth$user, {
    others_wishlist(
      shinymanager::read_db_decrypt(con, name = "wishlist", passphrase = DB_PASSPHRASE) %>%
        dplyr::filter(receiver != res_auth$user)
    )

    user_wishlist(
      shinymanager::read_db_decrypt(con, name = "wishlist", passphrase = DB_PASSPHRASE) %>%
        dplyr::filter(receiver == res_auth$user) %>%
        dplyr::pull(wishlist) %>%
        as.character()
    )
  }, once = TRUE)

  output$gifter = renderText({
    paste("Welcome back,", to_title_case(res_auth$user))
  })

  output$receiver = renderText({
    giftee_name = shinymanager::read_db_decrypt(con, name = "pairs", passphrase = DB_PASSPHRASE) %>%
      dplyr::filter(gifter == res_auth$user) %>%
      dplyr::pull(receiver) %>%
      to_title_case()

    return (paste("You are gifting to", to_title_case(giftee_name)))
  })

  output$receiver_wishlist = renderText({
    user_giftee = read_db_decrypt(con, name = "pairs", passphrase = DB_PASSPHRASE) %>%
      dplyr::filter(gifter == res_auth$user) %>%
      dplyr::pull(receiver)

    receiver_wishlist = others_wishlist() %>%
      dplyr::filter(receiver == user_giftee) %>%
      dplyr::pull(wishlist) %>%
      as.character()

    return(receiver_wishlist)
  })

  output$edit_wishlist_ui = renderUI({
    textAreaInput("user_wishlist",
                  "Update your wishlist:",
                  value = user_wishlist())
  })

  output$my_wishlist = renderText({
    user_wishlist()
  })

  observeEvent(input$update_wishlist, {
    # Update user wishlist
    user_wishlist(input$user_wishlist)

    # Save the user wishlist to database
    rbind(
      others_wishlist(),
      tibble::tibble(receiver = res_auth$user, wishlist = user_wishlist())
    ) %>%
      shinymanager::write_db_encrypt(con,
                                     value = .,
                                     name = "wishlist",
                                     passphrase = DB_PASSPHRASE)
  })

}
