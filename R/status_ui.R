#' Shiny UI for Resilient Community Status page
#'
#' Intended to be used in status_app, player_app, and control_app.
#' 
#' @family Status Modules
#' 
#' @param id  Application identifier for namespace.
status_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::fluidPage(
    shiny::fluidRow(persistent_ui("status", ns)),
    shiny::fluidRow(shinydashboard::valueBoxOutput(ns("infected_box")))
  )
}