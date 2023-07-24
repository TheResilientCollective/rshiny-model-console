#' Shiny UI for Resilient Community Newsfeed page
#'
#' Intended to be used in newsfeed_app, player_app, and control_app.
#' 
#' @family Newsfeed Modules
#' 
#' @param id  Application identifier for namespace.
newsfeed_ui <- function(id) {
  ns = shiny::NS(id)
  shiny::fluidPage(
    shiny::fluidRow(persistent_ui("newsfeed", ns)),
    shiny::fluidRow(shinydashboard::infoBoxOutput(ns("headline_box")))
  )
}
