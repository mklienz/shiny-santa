ui = dashboardPage(
  skin = "purple",
  header = dashboardHeader(title = "Harmonic Secret Santa",
                           titleWidth = 250),

  sidebar = dashboardSidebar(disable=TRUE),

  body = dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "loader.css")
    ),

    h1(textOutput("gifter")),
    fluidRow(
      box(
        width = 6,
        title = "About your Giftee",
        p("You are gifting to", textOutput("receiver")),
        p("Their wishlist:"),
        p(textOutput("receiver_wishlist"))
      ),
      box(
        width = 6,
        title = "Your Wishlist",
        p("Your current wishlist:"),
        p(textOutput("my_wishlist")),
        uiOutput("edit_wishlist_ui"),
        actionButton("update_wishlist", "Update")
      )
    ),
    div(class="loader"),


  )
)

ui = shinymanager::secure_app(ui)
