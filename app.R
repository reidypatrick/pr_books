library(shiny)
library(shinyWidgets)

# Define UI
ui <- fluidPage(
  titlePanel("Book Categories"),
  
  tabsetPanel(
    tabPanel("Novels", 
             h3("Novels"),
             fluidRow(
               column(4, 
                      img(src = "https://via.placeholder.com/150", alt = "Book Cover"),
                      h4("Dummy Novel 1"),
                      p("Author: John Doe"),
                      p("Year of Publication: 2020"),
                      numericInput("page_count_1", "Total Page Count:", value = 350, min = 1, step = 1)
               ),
               column(8, 
                      numericInput("current_page_1", "Current Page:", value = 0, min = 0, step = 1),
                      uiOutput("reading_progress_1")
               )
             ),
             fluidRow(
               column(4, 
                      img(src = "https://via.placeholder.com/150", alt = "Book Cover"),
                      h4("Dummy Novel 2"),
                      p("Author: Jane Smith"),
                      p("Year of Publication: 2022"),
                      numericInput("page_count_2", "Total Page Count:", value = 400, min = 1, step = 1)
               ),
               column(8, 
                      numericInput("current_page_2", "Current Page:", value = 0, min = 0, step = 1),
                      uiOutput("reading_progress_2")
               )
             )
    ),
    tabPanel("Poetry", 
             h3("Poetry"),
             fluidRow(
               column(4,
                      img(src = "https://via.placeholder.com/150", alt = "Book Cover"),
                      h4("Dummy Poetry Collection"),
                      p("Author: Emily Poet"),
                      p("Year of Publication: 2018")
               ),
               column(8,
                      checkboxGroupInput("poems_read", "Table of Contents:",
                                         choices = list(
                                           "Poem 1" = "poem1",
                                           "Poem 2" = "poem2",
                                           "Poem 3" = "poem3",
                                           "Poem 4" = "poem4"
                                         )),
                      uiOutput("poetry_progress")
               )
             )
    ),
    tabPanel("Short Fiction", 
             h3("Short Fiction"),
             p("Content for short fiction will go here.")
    ),
    tabPanel("Non-Fiction", 
             h3("Non-Fiction"),
             p("Content for non-fiction will go here.")),
    tabPanel("Drama", 
             h3("Drama"),
             p("Content for drama will go here.")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  output$reading_progress_1 <- renderUI({
    req(input$page_count_1)  # Ensure page count is available
    current_page <- ifelse(is.null(input$current_page_1) || is.na(input$current_page_1), 0, input$current_page_1)
    progress_value <- round((current_page / input$page_count_1) * 100)
    progressBar(
      id = "reading_progress_1", 
      value = progress_value, 
      total = 100, 
      display_pct = TRUE
    )
  })
  
  output$reading_progress_2 <- renderUI({
    req(input$page_count_2)  # Ensure page count is available
    current_page <- ifelse(is.null(input$current_page_2) || is.na(input$current_page_2), 0, input$current_page_2)
    progress_value <- round((current_page / input$page_count_2) * 100)
    progressBar(
      id = "reading_progress_2", 
      value = progress_value, 
      total = 100, 
      display_pct = TRUE
    )
  })
  
  output$poetry_progress <- renderUI({
    total_poems <- length(c("poem1", "poem2", "poem3", "poem4"))
    read_poems <- length(input$poems_read)
    progress_value <- round((read_poems / total_poems) * 100)
    progressBar(
      id = "poetry_progress", 
      value = progress_value, 
      total = 100, 
      display_pct = TRUE
    )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
