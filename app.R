library(shiny)
library(shinyWidgets)
library(dplyr)
source("R/scripting/config.R")
source("R/scripting/custom_css.R")

# Load Goodreads data ----------------------------------------------------------
goodreads_data <- get_goodreads_data() %>%
  mutate(Bookshelves = ifelse(is.na(Bookshelves), "read", Bookshelves)) %>%
  filter(Bookshelves %in% c("currently-reading", "to-read", "read"))

# UI ---------------------------------------------------------------------------
ui <- fluidPage(
  tags$head(tags$style(HTML(custom_css))), # Include custom CSS
  titlePanel("Book Categories"),
  tabsetPanel(
    tabPanel(
      "Novels",
      h3("Novels"),
      uiOutput("novels_ui") # Placeholder for dynamic content
    ),
    tabPanel("Poetry", h3("Poetry"), p("Poetry section content here.")),
    tabPanel("Short Fiction", h3("Short Fiction"), p("Content for short fiction.")),
    tabPanel("Non-Fiction", h3("Non-Fiction"), p("Content for non-fiction.")),
    tabPanel("Drama", h3("Drama"), p("Content for drama."))
  )
)

# Server -----------------------------------------------------------------------
server <- function(input, output, session) {
  # Dynamically generate UI for novels
  output$novels_ui <- renderUI({
    if (nrow(goodreads_data) == 0) {
      return(p("No books found."))
    }

    # Generate a list of book containers
    rows_list <- lapply(seq_len(nrow(goodreads_data)), function(i) {
      generate_book_container(goodreads_data[i, ], i)
    })

    do.call(tagList, rows_list)
  })

  # Dynamically generate progress bars for each book
  observe({
    lapply(seq_len(nrow(goodreads_data)), function(i) {
      output[[paste0("reading_progress_", i)]] <- render_progress_bar(input, goodreads_data[i, ], i)
    })
  })
}

# Run App ----------------------------------------------------------------------
shinyApp(ui = ui, server = server)
