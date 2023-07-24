#' Run the player shiny app
#' 
#' @family Shiny App Runners
#' 
#' @export
run_player_app <- function() {
  shiny::runApp(
    appDir = system.file("player_app", package="resilientgames")
  )
}
