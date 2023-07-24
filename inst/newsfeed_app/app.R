#
# Simple viewer for the Resilient Game Player Newsfeed 
#

app_id = "newsfeed"

ui <- shinydashboard::dashboardPage(
  skin = "green",
  shinydashboard::dashboardHeader(title = "Resilient Community Newsfeed", 
                                  titleWidth = 300),
  shinydashboard::dashboardSidebar(disable = TRUE),
  shinydashboard::dashboardBody(
    newsfeed_ui(app_id)
  )
)

server <- function(input, output, session) {
  newsfeed_server(app_id)
}

shiny::shinyApp(ui, server)
