library(shiny)
library(dplyr)
library(shinyWidgets)
library(shinyjs)
source("R/scripting/config.R")
source("R/scripting/custom_css.R")

# Load Goodreads data ----------------------------------------------------------
goodreads_data <- get_goodreads_data()
novels <- filter_novels(goodreads_data)
currently_reading <- filter_currently_reading(novels)
poetry <- filter_poetry(goodreads_data)
short_fiction <- filter_short_fiction(goodreads_data)
drama <- filter_drama(goodreads_data)
non_fiction <- filter_non_fiction(goodreads_data)

# UI ---------------------------------------------------------------------------

ui <- fluidPage(
  useShinyjs(), # Initialize shinyjs
  tags$head(tags$style(HTML(custom_css))),
  titlePanel("Book Categories"),
  tabsetPanel(
    ui_novels(),
    ui_poetry(),
    ui_short_fiction(),
    ui_drama(),
    ui_non_fiction()
  )
)

# Server -----------------------------------------------------------------------
server <- function(input, output, session) {
  ## Toggle sections ------------------------------------------------------------
  observeEvent(input$toggle_currently_reading, {
    toggle("currently_reading_section")
  })
  observeEvent(input$toggle_read, {
    toggle("read_section")
  })
  observeEvent(input$toggle_want_to_read, {
    toggle("want_to_read_section")
  })
  observeEvent(input$toggle_did_not_finish, {
    toggle("did_not_finish_section")
  })

  ## Novel Sections ---------------------------------------------------------
  output$currently_reading_ui <- ui_novels_currently_reading(currently_reading)
  output$want_to_read_ui <- ui_novels_want_to_read(novels)
  output$read_ui <- ui_novels_read_ui(novels)
  output$did_not_finish_ui <- ui_novels_did_not_finish_ui(novels)
  output$poetry_ui <- render_poetry_ui(poetry)

  # Novel Progress Bars --------------------------------------------------------
  observe({
    lapply(seq_len(nrow(currently_reading)), function(i) {
      output[[paste0("reading_progress_", i)]] <- render_progress_bar(input, currently_reading[i, ], i)
    })
  })
}


# Run App ----------------------------------------------------------------------
shinyApp(ui = ui, server = server)
