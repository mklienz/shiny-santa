ui = dashboardPage(
  skin = "purple",
  header = dashboardHeader(title = "Harmonic Secret Santa",
                           titleWidth = 250),

  sidebar = dashboardSidebar(
    collapsed = TRUE,
    width = 250,
    passwordInput("new_pw", "Update your password"),
    actionButton("update_pw", "Update"),
    br(),
    box(
      width = 12,
      background = "navy",
      collapsible = TRUE,
      collapsed = TRUE,
      title = "About your Giftee",
      p(textOutput("receiver")),
      p("Their wishlist:"),
      p(textOutput("receiver_wishlist"))
    )
  ),

  body = dashboardBody(
    # The app
    h1(textOutput("gifter")),
    p("Check the sidebar to learn about your giftee"),
    fluidRow(
      box(
        width = 6,
        title = "Your Wishlist",
        p("Your current wishlist:"),
        p(textOutput("my_wishlist")),
        uiOutput("edit_wishlist_ui"),
        actionButton("update_wishlist", "Update")
      )
    ),

    # JS for password change
    tags$script(HTML(
      "
      $('#update_pw').on('click', function() {
        $(this).prop('disabled', true);
      });

      Shiny.addCustomMessageHandler('changedPassword', passwordAlert);

      function passwordAlert(msg) {
        alert(msg);
        $('#update_pw').prop('disabled', false);
      }
      "
    ))
  )
)

ui = shinymanager::secure_app(ui)
