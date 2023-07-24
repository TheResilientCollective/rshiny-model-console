#' Server for one of our persistent data modules.
#' 
#' This is a component for use in either the status or newsfeed module.
#' 
#' Set up Consumer or Editor mode based on whether a reactive data object is
#' passed in (Editor handles data in memory, Consumers watch a file).
#'
#' Observe events on the Publish button (will be enabled in Editor mode only),
#' and write current data out to file in that case.
#' 
#' @family Shared Data Methods
#' 
#' @param id Application id for running app.
#' @param file_name Name of file for persistent storage.
#' @param reactive_data Optional reactive object for Editor mode.
#' @param ... Other args passed through as defaults to data_file_watcher.
persistent_server <- function(id, file_name, reactive_data=NULL, ...) {
  is_editor <- !is.null(reactive_data)
  shiny::moduleServer(
    id,
    function(input, output, session) {
      output$persistentMode <- shiny::renderText({
        if (is_editor) {
          return("Editor")
        }
        return("Consumer")
      })
      shiny::outputOptions(output, 'persistentMode', suspendWhenHidden = FALSE)

      shiny::observeEvent(
        input$publishButton, 
        {
          if (is_editor) {
            persistent_data_write(file_name, reactive_data())
          }
        }
      )

      shiny::reactive(persistent_data_watcher(file_name, reactive_data, ...))
    }
  )
}