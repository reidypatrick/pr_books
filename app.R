source("R/scripting/config.R")
source("R/scripting/custom_css.R")

# Load Goodreads data -------------------------------------------------------------------------------------------------
goodreads_data <- get_goodreads_data(use_cache = FALSE)

# UI ------------------------------------------------------------------------------------------------------------------

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

# Server --------------------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
  ## Set reactive values
  reactive_data <- reactiveVal(as.data.frame(goodreads_data))

  ## Novel Section ---------------------------------------------------------------------------------------------------
  output$currently_reading_ui <- render_ui_currently_reading(goodreads_data)
  output$want_to_read_ui <- render_ui_want_to_read(goodreads_data)
  output$read_ui <- render_ui_novels_read(goodreads_data)
  output$did_not_finish_ui <- render_ui_did_not_finish(goodreads_data)

  ### Observe reactive elements ---------------------------------------------------------------------------------------
  observe({
    data <- reactive_data()
    #### Observe Shelves ----------------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("shelf_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Bookshelves[i] <- input[[paste0("shelf_", data$Book.Id[i])]]
        reactive_data(data)

        output$currently_reading_ui <- render_ui_currently_reading(data)
        output$want_to_read_ui <- render_ui_want_to_read(data)
        output$read_ui <- render_ui_novels_read(data)
        output$did_not_finish_ui <- render_ui_did_not_finish(data)

        cache <<- data
      })
    })

    #### Observe Novel Progress Bars -----------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("current_page_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Current.Page[i] <- input[[paste0("current_page_", data$Book.Id[i])]]
        reactive_data(data)
        output[[paste0("reading_progress_", data$Book.Id[i])]] <- render_progress_bar(data[i, ])
        cache <<- data
      })
    })
  })

  ## Poetry Section ---------------------------------------------------------------------------------------------------
  output$poetry_ui <- render_poetry_ui(poetry)

  ## Short Fiction Section --------------------------------------------------------------------------------------------
  output$short_fiction_ui <- render_short_fiction_ui(short_fiction)

  ## Drama Section ----------------------------------------------------------------------------------------------------
  output$drama_ui <- render_drama_ui(drama)

  ## Non-Fiction Section ----------------------------------------------------------------------------------------------
  output$non_fiction_ui <- render_non_fiction_ui(non_fiction)
}



# Run App -------------------------------------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)
