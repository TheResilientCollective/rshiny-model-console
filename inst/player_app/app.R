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
      status_ui(app_id)
    ),
    shiny::fluidRow(
      newsfeed_ui(app_id)
    )
  )
)

server <- function(input, output, session) {
  status_server(app_id)
  newsfeed_server(app_id)
}

shiny::shinyApp(ui, server)
