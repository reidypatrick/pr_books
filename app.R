library(shiny)
library(shinyWidgets)
source("R/scripting/config.R")

# Load Goodreads data
goodreads_data <- get_goodreads_data()[1:4,]

# Custom CSS
custom_css <- "
  .book-container {
    border: 2px solid #ddd;
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 20px;
    background-color: #f9f9f9;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  .book-container:hover {
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
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
    color: #333;
  }
  .book-author {
    font-size: 1.2em;
    color: #555;
  }
  .book-year {
    font-size: 1em;
    color: #777;
  }
  .progress-bar-container {
    margin-top: 10px;
  }
"

# UI
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

# Server
server <- function(input, output, session) {
  
  # Dynamically generate UI for novels
  output$novels_ui <- renderUI({
    if (nrow(goodreads_data) == 0) {
      return(p("No books found."))
    }
    
    rows_list <- lapply(seq_len(nrow(goodreads_data)), function(i) {
      div(
        class = "book-container",
        fluidRow(
          column(
            4,
            div(
              class = "book-cover",
              img(
                src = tryCatch(get_goodreads_cover(goodreads_data$`Book Id`[i]), error = function(e) ""),
                alt = "Book Cover",
                height = "200px",
                width = "auto"
              )
            )
          ),
          column(
            8,
            div(
              class = "book-details",
              h4(class = "book-title", goodreads_data$Title[i]),
              p(class = "book-author", paste("Author:", goodreads_data$Author[i])),
              p(class = "book-year", paste("Year of Publication:", goodreads_data$`Original Publication Year`[i])),
              p(paste("Total Pages:", goodreads_data$`Number of Pages`[i])),
              numericInput(
                inputId = paste0("current_page_", i),
                label = "Current Page:",
                value = 0, # Default to 0
                min = 0,
                step = 1
              ),
              div(
                class = "progress-bar-container",
                uiOutput(paste0("reading_progress_", i))
              )
            )
          )
        )
      )
    })
    
    do.call(tagList, rows_list)
  })
  
  # Dynamically generate progress bars for each book
  observe({
    lapply(seq_len(nrow(goodreads_data)), function(i) {
      output[[paste0("reading_progress_", i)]] <- renderUI({
        # Get total pages from the dataset
        total_pages <- goodreads_data$`Number of Pages`[i]
        
        # Get current page input, defaulting to 0 if empty or invalid
        current_page <- tryCatch({
          as.numeric(input[[paste0("current_page_", i)]])
        }, error = function(e) {
          0
        })
        
        # Ensure current_page is valid
        if (is.na(current_page) || current_page < 0) {
          current_page <- 0
        }
        
        # Calculate progress
        progress_value <- round((current_page / total_pages) * 100)
        
        # Ensure progress_value is within 0-100
        progress_value <- max(0, min(100, progress_value))
        
        # Render progress bar
        progressBar(
          id = paste0("progress_", i),
          value = progress_value,
          total = 100,
          display_pct = TRUE
        )
      })
    })
  })
}

# Run App
shinyApp(ui = ui, server = server)