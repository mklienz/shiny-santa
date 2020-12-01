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
        p("Your current wishlist:"),
        p(textOutput("my_wishlist")),
        uiOutput("edit_wishlist_ui"),
        actionButton("update_wishlist", "Update")
      )
    )

  )
)

ui = shinymanager::secure_app(ui, enable_admin = TRUE)
