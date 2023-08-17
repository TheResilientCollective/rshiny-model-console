#' Shiny server method for Resilient Community Newsfeed page
#'
#' Intended to be used in newsfeed_app, player_app, and control_app.
#' TODO: replace data list with a table, modify viewer accordingly
#' 
#' @family Newsfeed Modules
#' 
#' @param id  Application identifier for namespace.
#' @param reactive_feed Override persistent storage with a reactive object
#' @export
newsfeed_server <- function(id, reactive_feed=NULL) {

  shiny::moduleServer(
    id,
    function(input, output, session) {
      feed_provider <- persistent_server(
        "newsfeed",
        file_name = "news_feed.rds",
        reactive_data=reactive_feed,
        title = "Messages will go here",
        message = "Stay tuned for messages",
        icon = shiny::icon("television", lib = "glyphicon"),
        color = "purple"
      )

      output$headline_box <- shinydashboard::renderInfoBox({
        feed <- feed_provider()
        shinydashboard::infoBox(
          feed()$title, 
          feed()$message, 
          icon = feed()$icon,
          color = feed()$color
        )
      })
    } # server function
  ) # moduleServer

} # newsfeed_server
