#
# Simple viewer for the Resilient Game Player Application
#

app_id = "player"

ui <- shinydashboard::dashboardPage(
  skin = "green",
  shinydashboard::dashboardHeader(title = "Resilient Community"),
  shinydashboard::dashboardSidebar(disable = TRUE),
  shinydashboard::dashboardBody(
    shiny::fluidRow(
      resilientgames::status_ui(app_id)
    ),
    shiny::fluidRow(
      resilientgames::newsfeed_ui(app_id)
    )
  )
)

server <- function(input, output, session) {
  resilientgames::status_server(app_id)
  resilientgames::newsfeed_server(app_id)
}

shiny::shinyApp(ui, server)
