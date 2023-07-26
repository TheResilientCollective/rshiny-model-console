#' Shiny UI for Resilient Community Model Editor Tab
#' 
#' @family Controller Modules
#' 
#' @param id  Application identifier for namespace.
model_editor_server <- function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      rv <- shiny::reactiveValues(original_params = NULL, cur_params = NULL)
      
      shiny::observeEvent(input$model_file, {
        file <- input$model_file
        ext <- tools::file_ext(file$datapath)
        
        req(file)
        
        validate(need(ext == "xmile", "Please upload an xmile file"))
        
        df <- readsdr::read_xmile_constants(file$datapath)
        dt_cols <- c("name", "dimensions", "subscript", "value", "units", "doc")
        rv$original_params <- df
        rv$cur_params <- df
        
        shiny::updateSliderInput(session, "misinformation_capacity", 
                                 value = as.numeric(df[3, "value"]))
        shiny::updateSliderInput(session, "infectivity", 
                                 value = as.numeric(df[4, "value"]))
        shiny::updateSliderInput(session, "baseline_contact_rate", 
                                 value = as.numeric(df[5, "value"]))
      })
      
      shiny::observeEvent(input$misinformation_capacity, {
        if (is.null(rv$cur_params)) return();
        rv$cur_params[3, "value"] <- input$misinformation_capacity
      })
      shiny::observeEvent(input$infectivity, {
        if (is.null(rv$cur_params)) return();
        rv$cur_params[4, "value"] <- input$infectivity
      })
      shiny::observeEvent(input$baseline_contact_rate, {
        if (is.null(rv$cur_params)) return();
        rv$cur_params[5, "value"] <- input$baseline_contact_rate
      })
      
      output$parameter_table <- DT::renderDT(
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
        
        if (names(rv$cur_params)[clmn] != "value") {
          return()
        }
        rv$cur_params[row, clmn] <- val
        if (row == 3) {
          var <- "misinformation_capacity"
        } else if (row == 4) {
          var <- "infectivity"
        } else if (row == 5) {
          var <- "baseline_contact_rate"
        }
        shiny::updateSliderInput(session, var, value = val)
      })
    }
  )
}
