source("R/scripting/config.R")
source("R/scripting/custom_css.R")

# Load Goodreads data -------------------------------------------------------------------------------------------------
goodreads_data <- get_goodreads_data(use_cache = FALSE)
temp_activity_data <- get_temp_activity_data()

# UI ------------------------------------------------------------------------------------------------------------------

ui <- fluidPage(
  useShinyjs(),
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
  ## Set reactive values ----------------------------------------------------------------------------------------------
  reactive_data <- reactiveVal(as.data.frame(goodreads_data))

  ## Novel Section ----------------------------------------------------------------------------------------------------
  output$activity_grid <- render_activity_grid(temp_activity_data)
  output$currently_reading_ui <- render_ui_currently_reading(goodreads_data)
  output$want_to_read_ui <- render_ui_want_to_read(goodreads_data)
  output$read_ui <- render_ui_novels_read(goodreads_data)
  output$did_not_finish_ui <- render_ui_did_not_finish(goodreads_data)

  ## Poetry Section ---------------------------------------------------------------------------------------------------
  output$poetry_ui <- render_poetry_ui(goodreads_data)

  ## Short Fiction Section --------------------------------------------------------------------------------------------
  output$short_fiction_ui <- render_short_fiction_ui(goodreads_data)

  ## Drama Section ----------------------------------------------------------------------------------------------------
  output$drama_ui <- render_drama_ui(goodreads_data)

  ## Non-Fiction Section ----------------------------------------------------------------------------------------------
  output$non_fiction_ui <- render_non_fiction_ui(goodreads_data)

  ## Observe reactive elements ----------------------------------------------------------------------------------------
  observe({
    data <- reactive_data()
    ### Observe Shelves -----------------------------------------------------------------------------------------------
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

    ### Observe Novel Progress Bars -----------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("current_page_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Current.Page[i] <- input[[paste0("current_page_", data$Book.Id[i])]]
        reactive_data(data)
        output[[paste0("reading_progress_", data$Book.Id[i])]] <- render_progress_bar(data[i, ])
        cache <<- data
      })
    })

    ### Observe Edit Page Count ---------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("show_numeric_dialog_", data$Book.Id[i])]], {
        showModal(modalDialog(
          title = "Edit Page Count",
          numericInput(
            inputId = paste0("page_count_", data$Book.Id[i]),
            label = "Page Count",
            value = 0
          ),
          footer = tagList(
            modalButton("Cancel"),
            actionButton(
              input = paste0("submit_page_count_", data$Book.Id[i]),
              label = "Submit"
            )
          )
        ))
      })
    })

    ### Observe Edit Cover --------------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("show_text_dialog_", data$Book.Id[i])]], {
        showModal(modalDialog(
          title = "Enter Text",
          textInput(
            inputId = paste0("cover_url_", data$Book.Id[i]),
            label = "Cover URL"
          ),
          footer = tagList(
            modalButton("Cancel"),
            actionButton(
              input = paste0("submit_cover_url_", data$Book.Id[i]),
              label = "Submit"
            )
          )
        ))
      })
    })

    ### Observe New Page Count ----------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("submit_page_count_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Number.of.Pages[i] <- input[[paste0("page_count_", data$Book.Id[i])]]
        reactive_data(data)
        cache <<- data
        removeModal()
      })
    })

    ### Observe New Cover ---------------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("submit_cover_url_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Cover_URL[i] <- input[[paste0("cover_url_", data$Book.Id[i])]]
        reactive_data(data)
        cache <<- data
        removeModal()
      })
    })

    ### Observe Edit Dates Read ---------------------------------------------------------------------------------------
    # lapply(seq_along(data$Book.Id), function(i) {
    #   observeEvent(input[[paste0("show_numeric_dialog_", data$Book.Id[i])]], {
    #     showModal(modalDialog(
    #       title = "Edit Page Count",
    #       numericInput(
    #         inputId = paste0("page_count_", data$Book.Id[i]),
    #         label = "Page Count",
    #         value = 0
    #       ),
    #       footer = tagList(
    #         modalButton("Cancel"),
    #         actionButton(
    #           input = paste0("submit_page_count_", data$Book.Id[i]),
    #           label = "Submit"
    #         )
    #       )
    #     ))
    #   })
    # })
  })
}

# Run App -------------------------------------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)
