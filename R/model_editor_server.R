#' Shiny UI for Resilient Community Model Editor Tab
#' 
#' @family Controller Modules
#' 
#' @param id  Application identifier for namespace.
model_editor_server <- function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      rv_model <- shiny::reactiveValues(cur_params = NULL,
                                        xmile_params = NULL,
                                        cur_xmile = NULL,
                                        xmile_file_path = NULL)
      rv_changed <- shiny::reactiveVal(FALSE)

      observeEvent(rv_changed(), {
        shinyjs::toggleState("mergeButton", condition = rv_changed())
        shinyjs::toggleState("revertButton", condition = rv_changed())
      })
      # This one depends on everything...
      observe({
        shinyjs::toggleState(
          "downloadButton", 
          condition = !(is.null(rv_model$cur_params) | rv_changed())
        )
      })
      
      update_sliders_for_params <- function(params) {
        shiny::updateSliderInput(session, "misinformation_capacity", 
                                 value = as.numeric(params[3, "value"]))
        shiny::updateSliderInput(session, "infectivity", 
                                 value = as.numeric(params[4, "value"]))
        shiny::updateSliderInput(session, "baseline_contact_rate", 
                                 value = as.numeric(params[5, "value"]))
      }

      shiny::observeEvent(input$uploadButton, {
        tags <- shiny::tagList(
          fileInput(session$ns("upload_filename"), 
                    "Choose Model File", 
                    accept = ".xmile")
        )
        if (!is.null(isolate(rv_model$cur_params))) {
          tags <- shiny::tagAppendChild(
            tags,
            shiny::strong(
              paste0("Warning!  Uploading a new model will replace",
                     " current model and any chances will be lost!")
            )
          )
        }
        shiny::showModal(shiny::modalDialog(tags, title = "Upload Model File"))
      }) # observeEvent

      shiny::observeEvent(input$upload_filename, {
        file <- input$upload_filename

        req(file)
        
        parsed <- readsdr::read_xmile_constants(file$datapath)
        rv_model$cur_params <- parsed$constants
        rv_model$xmile_params <- parsed$constants
        rv_model$cur_xmile <- parsed$xmile
        rv_model$xmile_file_path <- file$name
        rv_changed(FALSE)

        update_sliders_for_params(parsed$constants)
        shiny::removeModal()
      })

      output$downloadButton <- downloadHandler(
        filename = function() {
          sub(".xmile", "_modified.xmile", rv_model$xmile_file_path)
        },
        contentType = "text/xmile",
        content = function(file) {
          notification_id <- shiny::showNotification(
            "Preparing Download...",
            duration = NULL,
            closeButton = FALSE
          )
          on.exit(removeNotification(notification_id), add = TRUE)
          xml2::write_xml(rv_model$cur_xmile, file)
        }
      )
      outputOptions(output, "downloadButton", suspendWhenHidden = FALSE)
      
      on_slider_event <- function(var, idx) {
        if (is.null(rv_model$cur_params)) return();
        if (input[[var]] == rv_model$cur_params[idx, "value"]) return();
        rv_model$cur_params[idx, "value"] <- input[[var]]
        rv_changed(TRUE)
      }

      shiny::observeEvent(input$misinformation_capacity, {
        on_slider_event("misinformation_capacity", 3)
      })
      shiny::observeEvent(input$infectivity, {
        on_slider_event("infectivity", 4)
      })
      shiny::observeEvent(input$baseline_contact_rate, {
        on_slider_event("baseline_contact_rate", 5)
      })
      
      editable_columns <- function(table) {
        if (is.null(table)) return(c())
        # NOTE: DT uses 0-based index
        (1:ncol(table))[-grep("value", colnames(table))] - 1
      }

      output$parameter_table <- DT::renderDT(
        rv_model$cur_params,
        options = list(scrollX = TRUE),
        rownames = FALSE,
        selection = "none",
        editable = list(
          target = "cell",
          disable = list(columns = editable_columns(rv_model$cur_params))
        )
      )

      shiny::observeEvent(
        input$mergeButton, 
        {
          readsdr::merge_xmile_constants(rv_model$cur_xmile,
                                         rv_model$cur_params)
          rv_model$xmile_params <- rv_model$cur_params
          rv_changed(FALSE)
        }
      )

      shiny::observeEvent(
        input$revertButton, 
        {
          print("Reverting xmile changes!")
          rv_model$cur_params <- rv_model$xmile_params
          rv_changed(FALSE)
          update_sliders_for_params(isolate(rv_model$cur_params))        
        }
      )

      ## handle updates in table cells
      shiny::observeEvent(input$parameter_table_cell_edit, {
        row  <- input$parameter_table_cell_edit$row
        clmn <- input$parameter_table_cell_edit$col + 1
        val <- input$parameter_table_cell_edit$value
        
        if (names(rv_model$cur_params)[clmn] != "value") {
          return()
        }
        if (val == rv_model$cur_params[row, clmn]) return();
        rv_model$cur_params[row, clmn] <- val
        rv_changed(TRUE)
        if (row == 3) {
          var <- "misinformation_capacity"
        } else if (row == 4) {
          var <- "infectivity"
        } else if (row == 5) {
          var <- "baseline_contact_rate"
        } else {
          # Not a slider
          return()
        }
        shiny::updateSliderInput(session, var, value = val)
      })
    }
  )
}
