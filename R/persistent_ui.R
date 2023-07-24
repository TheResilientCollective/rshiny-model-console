#' UI for one of our persistent data modules.
#' 
#' This is a component for use in either the status or newsfeed module.
#' 
#' This consists of a "Publish" action button which is hidden unless the module
#' is in editor mode.
#' 
#' Note on namespaces: because this module is contained within one of the
#' newsfeed or status modules, which in turn is contained within the app, the
#' moduleServer method composes those namespaces.  Thus ui elements need to 
#' use a composed namespace in order to match.  For example, in the controller
#' app status panel, output$persistentMode set in persistent_server will be 
#' visibile to the js code as `output['controller-status-persistentMode']`.
#' 
#' @family Shared Data Methods
#' 
#' @param id Application id for running app.
#' @param parent_ns Namespace function of the parent module (must be composed).
persistent_ui <- function(id, parent_ns) {
  ns = shiny::NS(parent_ns(id))
  shiny::tagList(
    shiny::conditionalPanel(
      condition = 'output.persistentMode == "Editor"',
      ns = ns,
      shiny::actionButton(ns("publishButton"),
                          "Publish!",
                          icon = shiny::icon("file-upload"))
    )
  ) # tagList
} # ui function
