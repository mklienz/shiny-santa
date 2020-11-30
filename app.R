library(shiny)
library(shinydashboard)
library(shinymanager)
library(DBI)
library(magrittr)

DB_PASSPHRASE = "my_custom_pass"
con = DBI::dbConnect(RSQLite::SQLite(), dbname = "db.sqlite")

ui = dashboardPage(
  skin = "purple",
  header = dashboardHeader(title = "Harmonic Secret Santa",
                           titleWidth = 250),
  sidebar = dashboardSidebar(disable=TRUE),
  body = dashboardBody(
    h1(textOutput("gifter")),
    fluidRow(
      box(
        width = 6,
        title = "About your Giftee",
        textOutput("receiver")
      ),
      box(
        width = 6,
        title = "Your Wishlist",
        uiOutput("wishlist"),
        actionButton("update_wishlist",
                     "Update")
      )
    )

  )
)

ui = secure_app(ui, enable_admin = TRUE)

server = function(input, output) {

  res_auth = secure_server(
    check_credentials = check_credentials(
      db = "db.sqlite",
      passphrase = DB_PASSPHRASE
    )
  )

  output$gifter = renderText({paste("Welcome back,", res_auth$user)})

  output$receiver = renderText({
    user_giftee = read_db_decrypt(con, name = "pairs", passphrase = DB_PASSPHRASE) %>%
      dplyr::filter(gifter == res_auth$user) %>%
      dplyr::pull(receiver)

    receiver_wishlist = read_db_decrypt(con, name = "wishlist", passphrase = DB_PASSPHRASE) %>%
      dplyr::filter(receiver == user_giftee) %>%
      dplyr::pull(wishlist)

    return(paste0(
      "You are gifting to ",
      user_giftee,
      "\n",
      "Their wishlist contains:\n",
      receiver_wishlist
    ))
  })

  output$wishlist = renderUI({
    # Get the user's wishlist
    user_wishlist = read_db_decrypt(con, name = "wishlist", passphrase = DB_PASSPHRASE) %>%
      dplyr::filter(receiver == res_auth$user) %>%
      dplyr::pull(wishlist)

    textInput("user_wishlist",
              "Update your wishlist:",
              value = user_wishlist)
  })

  observeEvent(input$update_wishlist, {

  })
}

shinyApp(ui, server)
