
app_id = "controller"

#' UI panel with editor for model
#' 
#' Smaller left panel with:
#' 1. selector for team 
#'   - add/delete team control
#' 2. model file chooser
#'   - enabled once a team is selected
#' 3. high level control sliders
#'   - subset of editable parameters
#'
#' Table view on right with all editable parameters for each model
model_editor_panel <- function() {
  shiny::fluidRow(
    shiny::column(
      3,
      fileInput("model_file", "Choose Model File", accept = ".csv"),

      sliderInput("misinformation_capacity",
                  "Misinformation Capacity",
                  min = 0,
                  max = 1.0,
                  step = 0.01,
                  value = 0.5),
      sliderInput("infectivity",
                  "Infectivity",
                  min = 0,
                  max = 1.0,
                  step = 0.01,
                  value = 0.5),
      sliderInput("baseline_contact_rate",
                  "Baseline Contact Rate",
                  min = 0,
                  max = 1.0,
                  step = 0.01,
                  value = 0.5),
      sliderInput("confirmed_cases",
                  "Direct Confirmed Cases",
                  min = 0,
                  max = 10000000,
                  step = 100,
                  value = 235676)
    ),  # column
    shiny::column(
      9,
      DT::dataTableOutput("parameter_table")
    ) # column
  ) # fluidRow
}

#' Control App UI
ui <- shinydashboard::dashboardPage(
  title = "Resilient Community Model",
  skin = "red",
  shinydashboard::dashboardHeader(
    title = "Resilient Community Model", 
    titleWidth = 300
  ),
  shinydashboard::dashboardSidebar(
    shinydashboard::sidebarMenu(
      shinydashboard::menuItem(
        "Edit Model",
        tabName = "model_editor",
        icon = shiny::icon("sliders"),
        badgeColor = "red"
      ),
      shinydashboard::menuItem(
        "Edit Newsfeed",
        tabName = "newsfeed_editor",
        icon = shiny::icon("pen-to-square"),
        badgeColor = "red"
      ),
      shinydashboard::menuItem(
        "Status",
        tabName = "status_viewer",
        icon = shiny::icon("chart-simple"),
        badgeColor = "green"
        ),
      shinydashboard::menuItem(
        "Newsfeed",
        tabName = "newsfeed_viewer",
        icon = shiny::icon("newspaper"),
        badgeColor = "green"
        ),
      collapse = TRUE
    ) # sidebarMenu
  ), # dashboardSidebar

  shinydashboard::dashboardBody(
    shinydashboard::tabItems(
      shinydashboard::tabItem(tabName = "model_editor",
                              model_editor_panel()),
      shinydashboard::tabItem(tabName = "newsfeed_editor",
                              h2("Newsfeed Editor Content")),
      shinydashboard::tabItem(tabName = "status_viewer", 
                              status_ui(app_id)),
      shinydashboard::tabItem(tabName = "newsfeed_viewer", 
                              newsfeed_ui(app_id))
    ) # tabItems
  ) # dashboardBody
)

server <- function(input, output, session) {
  rv <- shiny::reactiveValues(original_params = NULL, cur_params = NULL)

  status <- shiny::reactiveValues(confirmed_cases=0)
  status_server(app_id, shiny::reactive(status))
  feed <- shiny::reactiveValues(
    title = "Progress",
    message = "You're doing great!",
    icon = shiny::icon("thumbs-up", lib = "glyphicon"),
    color = "purple"
  )
  newsfeed_server(app_id, shiny::reactive(feed))
  
  shiny::observeEvent(input$model_file, {
    file <- input$model_file
    ext <- tools::file_ext(file$datapath)

    req(file)

    validate(need(ext == "csv", "Please upload a csv file"))

    df <- read.csv(file$datapath, header = TRUE)
    rv$original_params <- df
    rv$cur_params <- df
    shiny::updateSliderInput(session, "misinformation_capacity", value = df[1, 2])
    shiny::updateSliderInput(session, "infectivity", value = df[2, 2])
    shiny::updateSliderInput(session, "baseline_contact_rate", value = df[3, 2])
    shiny::updateSliderInput(session, "confirmed_cases", value = df[4, 2])
  })

  shiny::observeEvent(input$misinformation_capacity, {
    if (is.null(rv$cur_params)) return();
    rv$cur_params[1, 2] <- input$misinformation_capacity
  })
  shiny::observeEvent(input$infectivity, {
    if (is.null(rv$cur_params)) return();
    rv$cur_params[2, 2] <- input$infectivity
  })
  shiny::observeEvent(input$baseline_contact_rate, {
    if (is.null(rv$cur_params)) return();
    rv$cur_params[3, 2] <- input$baseline_contact_rate
  })
  shiny::observeEvent(input$confirmed_cases, {
    if (is.null(rv$cur_params)) return();
    rv$cur_params[4, 2] <- input$confirmed_cases
    status$confirmed_cases <- input$confirmed_cases
  })

  output$parameter_table <- DT::renderDataTable(
    rv$cur_params,
    options = list(scrollX = TRUE),
    rownames = FALSE,
    selection = "none",
    editable = list(target = "cell",
                    disable = list(columns = c(0)))
  )

  ## handle updates in table cells
  shiny::observeEvent(input$parameter_table_cell_edit, {
    row  <- input$parameter_table_cell_edit$row
    clmn <- input$parameter_table_cell_edit$col + 1
    val <- input$parameter_table_cell_edit$value
    rv$cur_params[row, clmn] <- val
    if (row == 1) {
      var <- "misinformation_capacity"
    } else if (row == 2) {
      var <- "infectivity"
    } else if (row == 3) {
      var <- "baseline_contact_rate"
    } else {
      var <- "confirmed_cases"
    }
    shiny::updateSliderInput(session, var, value = val)
  })
}

shiny::shinyApp(ui, server)
