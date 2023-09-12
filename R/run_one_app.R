#' Run a shiny app with options
#'
#' This sets up options, finds application dir, and calls shiny::runApp
#'
#' @param app_name Name of application to run (directory under apps)
#' @param data_path Path to use for shared data
#' @export
run_one_app <- function(app_name, data_path=NA) {
  if (is.na(data_path)) {
    data_path <- usethis::proj_path("output")
  }
  options(resilient.data = data_path)
  shiny::runApp(
    appDir = system.file(file.path("apps", app_name),
                         package = "resilientgames")
  )
}
