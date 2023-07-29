#' Shiny UI for Resilient Community Model Editor Tab
#' 
#' Smaller left panel with:
#' 1. selector for team (TODO)
#'   - add/delete team control
#' 2. model file chooser (upload xmile file)
#'   - enabled once a team is selected
#' 3. high level control sliders
#'   - subset of editable parameters?
#' 4. download button to export updated xmile file
#'
#' Table view on right with all editable parameters for each model
#' 
#' @family Controller Modules
#' 
#' @param id Application identifier.
model_editor_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::fluidRow(
    shiny::column(
      3,
      shiny::actionButton(ns("uploadButton"),
                          label = "New Model",
                          icon = shiny::icon("upload")
      ),
      shiny::downloadButton(ns("downloadButton"), label = "Download"),
      shiny::actionButton(ns("mergeButton"),
                          label = "Merge",
                          icon = shiny::icon("code-merge")
      ),
      shiny::actionButton(ns("revertButton"),
                          label = "Revert",
                          icon = shiny::icon("clock-rotate-left")
      ),
      sliderInput(ns("misinformation_capacity"),
                  "Misinformation Capacity",
                  min = 0,
                  max = 1.0,
                  step = 0.01,
                  value = 0.5),
      sliderInput(ns("infectivity"),
                  "Infectivity",
                  min = 0,
                  max = 1.0,
                  step = 0.01,
                  value = 0.5),
      sliderInput(ns("baseline_contact_rate"),
                  "Baseline Contact Rate",
                  min = 0,
                  max = 1.0,
                  step = 0.01,
                  value = 0.5)
    ),  # column
    shiny::column(
      9,
      DT::dataTableOutput(ns("parameter_table"))
    ) # column
  ) # fluidRow
}
