# This ensures we can find our R scripts from shiny-server

app_id = "controller"

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
        shinydashboard::menuItem(
          "Edit Newsfeed",
          tabName = "newsfeed_editor",
          icon = shiny::icon("pen-to-square"),
          badgeColor = "red"
        ),
        shinydashboard::menuItem(
          "Status",
          tabName = "status_viewer",
          icon = shiny::icon("chart-simple"),
          badgeColor = "green"
          ),
        shinydashboard::menuItem(
          "Newsfeed",
          tabName = "newsfeed_viewer",
          icon = shiny::icon("newspaper"),
          badgeColor = "green"
          ),
        collapse = TRUE
      ) # sidebarMenu
    ), # dashboardSidebar
  
    shinydashboard::dashboardBody(
      shinydashboard::tabItems(
        shinydashboard::tabItem(tabName = "model_editor",
                                resilientgames::model_editor_ui(app_id)
                                ),
        shinydashboard::tabItem(tabName = "newsfeed_editor",
                                h2("Newsfeed Editor Content")),
        shinydashboard::tabItem(
          tabName = "status_viewer",
          # TEMPORARY: To test "publish"
          shiny::fluidPage(
            shiny::fluidRow(
              shiny::sliderInput(
                "confirmed_cases",
                "EXAMPLE: Confirmed Cases Status",
                min = 0,
                max = 10000000,
                step = 100,
                value = 235676
              )
            ),
            fluidRow(resilientgames::status_ui(app_id))
          )
        ),
        shinydashboard::tabItem(tabName = "newsfeed_viewer", 
                                resilientgames::newsfeed_ui(app_id))
      ) # tabItems
    ) # dashboardPage
  ) # tagList
)

server <- function(input, output, session) {

  status <- shiny::reactiveValues(confirmed_cases=0)
  resilientgames::status_server(app_id, shiny::reactive(status))
  feed <- shiny::reactiveValues(
    title = "Progress",
    message = "You're doing great!",
    icon = shiny::icon("thumbs-up", lib = "glyphicon"),
    color = "purple"
  )
  resilientgames::newsfeed_server(app_id, shiny::reactive(feed))
  resilientgames::model_editor_server(app_id)

  shiny::observeEvent(input$confirmed_cases, {
    status$confirmed_cases <- input$confirmed_cases
  })
}

shiny::shinyApp(ui, server)
