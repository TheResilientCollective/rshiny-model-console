#
# Simple viewer for the Resilient Game Model Status
#

app_id = "status"

ui <- shinydashboard::dashboardPage(
  skin = "green",
  shinydashboard::dashboardHeader(title = "Resilient Community Status", 
                                  titleWidth = 300),
  shinydashboard::dashboardSidebar(disable = TRUE),
  shinydashboard::dashboardBody(
    status_ui(app_id)
  )
)

server <- function(input, output, session) {
  status_server(app_id)
}

shiny::shinyApp(ui, server)
