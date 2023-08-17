#' Run the controller shiny app
#' 
#' @family Shiny App Runners
#' 
#' @export
run_controller_app <- function() {
  shiny::runApp(
    appDir = system.file("apps/controller", package="resilientgames")
  )
}
