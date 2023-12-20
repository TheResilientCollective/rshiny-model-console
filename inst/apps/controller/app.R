# This ensures we can find our R scripts from shiny-server

app_id <- "controller"

#' Control App UI
ui <- tagList(
  # This is required for enable/disable on buttons, has to be at the top level.
  shinyjs::useShinyjs(),
  shinydashboard::dashboardPage(
    title = "Resilient Community Model",
    skin = "red",
    shinydashboard::dashboardHeader(
      title = "Resilient Community Model",
      titleWidth = 300
    ),
    shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(
        shinydashboard::menuItem(
          "Edit Model",
          tabName = "model_editor",
          icon = shiny::icon("sliders"),
          badgeColor = "red"
        ),
        collapse = TRUE
      ) # sidebarMenu
    ), # dashboardSidebar

    shinydashboard::dashboardBody(
      shinydashboard::tabItems(
        shinydashboard::tabItem(
          tabName = "model_editor",
          resilientgames::model_editor_ui(app_id)
        )
      ) # tabItems
    ) # dashboardPage
  ) # tagList
)

server <- function(input, output, session) {
  resilientgames::model_editor_server(app_id)
}

shiny::shinyApp(ui, server)
