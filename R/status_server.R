#' Shiny server method for Resilient Community Status page
#'
#' Intended to be used in status_app, player_app, and control_app.
#' 
#' @family Status Modules
#' 
#' @param id  Application identifier for namespace.
#' @param reactive_status Override persistent storage with a reactive object
status_server <- function(id, reactive_status = NULL) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      status_provider <- persistent_server(
        "status",
        file_name = "model_status.rds",
        reactive_data=reactive_status,
        confirmed_cases = 0
      )

      output$infected_box  <- shinydashboard::renderValueBox({
        status <- status_provider()
        status()$confirmed_cases %>%
          format(big.mark = " ", scientific = FALSE) %>%
          shinydashboard::valueBox("Confirmed",
                                   icon = shiny::icon("ambulance"),
                                   color = "purple")
      })

    } # server function
  ) # moduleServer

} # status_server


