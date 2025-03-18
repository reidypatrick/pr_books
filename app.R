source("R/scripting/config.R")
source("R/scripting/custom_css.R")

# 000 Load Goodreads data ---------------------------------------------------------------------------------------------
goodreads_data <- get_goodreads_data(use_cache = FALSE)
activity_data <- get_activity_data(use_cache = TRUE, activity_file_path = "data/output/activity_cache.csv")
cache <- list()


# 100 UI --------------------------------------------------------------------------------------------------------------

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

# 200 Server ----------------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
  ## 210 Set reactive values ------------------------------------------------------------------------------------------
  reactive_data <- reactiveVal(as.data.frame(goodreads_data))
  reactive_activity <- reactiveVal(as.data.frame(activity_data))
  
  ## 220 Get UI -------------------------------------------------------------------------------------------------------
  ### 221 Novel Section -----------------------------------------------------------------------------------------------
  output$activity_grid <- render_activity_grid(temp_activity_data)
  # ^^ temp activity grid to check ui vis ^^
  output$currently_reading_ui <- render_ui_currently_reading(goodreads_data)
  output$want_to_read_ui <- render_ui_want_to_read(goodreads_data)
  output$read_ui <- render_ui_novels_read(goodreads_data)
  output$did_not_finish_ui <- render_ui_did_not_finish(goodreads_data)

  ### 222 Poetry Section -----------------------------------------------------------------------------------------------
  output$poetry_ui <- render_poetry_ui(goodreads_data)

  ### 223 Short Fiction Section ----------------------------------------------------------------------------------------
  output$short_fiction_ui <- render_short_fiction_ui(goodreads_data)

  ### 224 Drama Section ------------------------------------------------------------------------------------------------
  output$drama_ui <- render_drama_ui(goodreads_data)

  ### 225 Non-Fiction Section ------------------------------------------------------------------------------------------
  output$non_fiction_ui <- render_non_fiction_ui(goodreads_data)

  ## 230 Observe reactive elements ------------------------------------------------------------------------------------
  observe({
    data <- reactive_data()
    activity <- reactive_activity()
    
    ### 231 Observe Shelves -------------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("shelf_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Bookshelves[i] <- input[[paste0("shelf_", data$Book.Id[i])]]
        reactive_data(data)

        output$currently_reading_ui <- render_ui_currently_reading(data)
        output$want_to_read_ui <- render_ui_want_to_read(data)
        output$read_ui <- render_ui_novels_read(data)
        output$did_not_finish_ui <- render_ui_did_not_finish(data)

        cache[["data"]] <<- data
      })
    })

    ### 232 Observe Novel Progress Bars -------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("current_page_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Current.Page[i] <- input[[paste0("current_page_", data$Book.Id[i])]]
        reactive_data(data)
        output[[paste0("reading_progress_", data$Book.Id[i])]] <- render_progress_bar(data[i, ])
        cache[["data"]] <<- data
      })
    })

    ### 233 Observe Edit Page Count ---------------------------------------------------------------------------------------
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

    ### 234 Observe Edit Cover --------------------------------------------------------------------------------------------
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

    ### 235 Observe New Page Count ----------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("submit_page_count_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Number.of.Pages[i] <- input[[paste0("page_count_", data$Book.Id[i])]]
        reactive_data(data)
        cache[["data"]] <<- data
        removeModal()
      })
    })

    ### 236 Observe New Cover ---------------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("submit_cover_url_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Cover_URL[i] <- input[[paste0("cover_url_", data$Book.Id[i])]]
        reactive_data(data)
        cache[["data"]] <<- data
        removeModal()
      })
    })

    ### 237 Observe Edit Dates Read ---------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("show_edit_dates_", data$Book.Id[i])]], {
        showModal(modalDialog(
          title = "Enter Date and Number",
          dateInput(
            input = paste0("date_read_", data$Book.Id[i]),
            label = "Select a date:",
            value = Sys.Date()
          ), 
          numericInput(
            input = paste0("pages_read_", data$Book.Id[i]),
            label = "Enter a number:",
            value = 0
          ), 
          footer = tagList(
            modalButton("Cancel"),
            actionButton(
              paste0("submit_dates_read_", data$Book.Id[i]),
              label = "Submit"
            ) 
          )
        ))
      })
    })

    ### 238 Observe New Dates Read ------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("submit_dates_read_", data$Book.Id[i])]], {
        activity <- reactive_activity()
        data <- reactive_data()
        
        new_activity <- activity %>% 
          add_row(
            book_id = data$Book.Id[i],
            date = input[[paste0("date_read_", data$Book.Id[i])]],
            no_of_pages = input[[paste0("pages_read_", data$Book.Id[i])]]
          )
        
        output[[paste0("activity_grid_", data$Book.Id[i])]] <- render_activity_grid(data[i, ], new_activity)
        
        cache[["activity"]] <<- new_activity
        removeModal()
      })
    })
    ### 239 Observe Activity Update -----------------------------------------------------------------------------------
    
  })
  
}

# 300 Run App ---------------------------------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)

# 400 Grab Cache ------------------------------------------------------------------------------------------------------
write_csv(cache[["data"]], paste0("data/output/", "cache_data.csv"))
write_csv(cache[["activity"]], paste0("data/output/", "cache_activity.csv"))
