library(shiny)
library(shinyWidgets)
library(dplyr)
source("R/scripting/config.R")

# Load Goodreads data ----------------------------------------------------------
goodreads_data <- get_goodreads_data() %>%
  mutate(Bookshelves = ifelse(is.na(Bookshelves), "read", Bookshelves)) %>%
  filter(Bookshelves %in% c("currently-reading", "to-read", "read"))

# Custom CSS for Dark Theme ---------------------------------------------------
custom_css <- "
  body {
    background-color: #121212;
    color: #e0e0e0;
  }
  .book-container {
    border: 2px solid #333;
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 20px;
    background-color: #1e1e1e;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
  }
  .book-container:hover {
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5);
  }
  .book-cover {
    text-align: center;
    margin-bottom: 15px;
  }
  .book-details {
    padding-left: 20px;
  }
  .book-title {
    font-size: 1.5em;
    font-weight: bold;
    color: #ffffff;
  }
  .book-author {
    font-size: 1.2em;
    color: #bbbbbb;
  }
  .book-year {
    font-size: 1em;
    color: #999999;
  }
  .progress-bar-container {
    margin-top: 10px;
  }
  .progress-bar {
    background-color: #333;
  }
  .progress-bar .progress {
    background-color: #4caf50;
  }
  .shiny-input-container {
    color: #e0e0e0;
  }
  .shiny-input-container label {
    color: #e0e0e0;
  }
  .shiny-numeric-input input {
    background-color: #333;
    color: #e0e0e0;
    border: 1px solid #555;
  }
  .tabsetPanel {
    background-color: #1e1e1e;
    border: 1px solid #333;
  }
  .nav-tabs > li > a {
    color: #e0e0e0;
    background-color: #333;
    border: 1px solid #555;
  }
  .nav-tabs > li.active > a {
    color: #ffffff;
    background-color: #1e1e1e;
    border: 1px solid #555;
  }
"

# Helper Functions -------------------------------------------------------------

# Function to generate a book container UI


# Function to calculate and render a progress bar


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
