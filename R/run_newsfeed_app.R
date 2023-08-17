#' Run the newsfeed shiny app
#' 
#' @family Shiny App Runners
#' 
#' @export
run_newsfeed_app <- function() {
  shiny::runApp(
    appDir = system.file("apps/newsfeed", package="resilientgames")
  )
}
