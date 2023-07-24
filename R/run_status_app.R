#' Run the status shiny app
#' 
#' @family Shiny App Runners
#' 
#' @export
run_status_app <- function() {
  shiny::runApp(
    appDir = system.file("status_app", package="resilientgames")
  )
}
