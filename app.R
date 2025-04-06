source("R/scripting/config.R")
source("R/scripting/custom_css.R")

# 000 Load Data -------------------------------------------------------------------------------------------------------

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
    ui_non_fiction(),
    footer = tagList(
      actionButton(
        paste0("save"),
        label = "Save"
      ),
      actionButton(
        paste0("add_book"),
        label = "Add Book"
      )
    )
  ),
)

# 200 Server ----------------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
  ## 210 Load Values ------------------------------------------------------------------------------------------
  sheet_id <- drive_get("pr_books/cache")

  goodreads_data <- read_sheet(
    ss = sheet_id,
    sheet = "data"
  )

  activity_data <- read_sheet(
    ss = sheet_id,
    sheet = "activity"
  )

  cache <- list()
  cache[["data"]] <- goodreads_data
  cache[["activity"]] <- activity_data

  #### 211 Set Reactive Values ----------------------------------------------------------------------------------------
  reactive_data <- reactiveVal(as.data.frame(goodreads_data))
  reactive_activity <- reactiveVal(as.data.frame(activity_data))

  temp_book <- list()

  for (i in seq_len(ncol(goodreads_data))) {
    temp_book[[paste0(colnames(goodreads_data)[i])]] <- ""
  }

  reactive_temp_book <- reactiveVal(temp_book)

  ## 220 Get UI -------------------------------------------------------------------------------------------------------
  ### 221 Novel Section -----------------------------------------------------------------------------------------------
  output$currently_reading_ui <- render_ui_currently_reading(goodreads_data)
  output$want_to_read_ui <- render_ui_want_to_read(goodreads_data)
  output$read_ui <- render_ui_novels_read(goodreads_data)
  output$did_not_finish_ui <- render_ui_did_not_finish(goodreads_data)

  #### 221.1 Activity Grids -------------------------------------------------------------------------------------------
  currently_reading <- goodreads_data %>% filter(Bookshelves == "currently-reading")
  lapply(seq_len(nrow(currently_reading)), function(i) {
    book <- currently_reading[i, ]
    output[[paste0("activity_grid_", book$Book.Id)]] <- render_activity_grid(book, activity_data)
  })


  ### 222 Poetry Section ----------------------------------------------------------------------------------------------
  output$poetry_ui <- render_poetry_ui(goodreads_data)

  ### 223 Short Fiction Section ---------------------------------------------------------------------------------------
  output$short_fiction_ui <- render_short_fiction_ui(goodreads_data)

  ### 224 Drama Section -----------------------------------------------------------------------------------------------
  output$drama_ui <- render_drama_ui(goodreads_data)

  ### 225 Non-Fiction Section -----------------------------------------------------------------------------------------
  output$non_fiction_ui <- render_non_fiction_ui(goodreads_data)

  ## 230 Observe reactive elements ------------------------------------------------------------------------------------
  observe({
    data <- reactive_data()

    ### 2301 Observe Shelves ------------------------------------------------------------------------------------------
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

    ### 2302 Observe Novel Progress Bars -------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("current_page_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Current.Page[i] <- input[[paste0("current_page_", data$Book.Id[i])]]
        isolate(reactive_data(data))
        output[[paste0("reading_progress_", data$Book.Id[i])]] <- render_progress_bar(data[i, ])
        cache[["data"]] <<- data
      })
    })

    ### 2303 Observe Edit Page Count ----------------------------------------------------------------------------------
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

    ### 2304 Observe Edit Cover ---------------------------------------------------------------------------------------
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

    ### 2305 Observe New Page Count -----------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("submit_page_count_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Number.of.Pages[i] <- input[[paste0("page_count_", data$Book.Id[i])]]
        reactive_data(data)
        cache[["data"]] <<- data
        removeModal()
      })
    })

    ### 2306 Observe New Cover -----------------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("submit_cover_url_", data$Book.Id[i])]], {
        data <- reactive_data()
        data$Cover_URL[i] <- input[[paste0("cover_url_", data$Book.Id[i])]]
        reactive_data(data)
        cache[["data"]] <<- data
        removeModal()
      })
    })

    ### 2307 Observe Edit Dates Read -----------------------------------------------------------------------------------
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

    ### 2308 Observe New Dates Read -----------------------------------------------------------------------------------
    lapply(seq_along(data$Book.Id), function(i) {
      observeEvent(input[[paste0("submit_dates_read_", data$Book.Id[i])]], {
        activity <- reactive_activity()
        data <- reactive_data()

        isolate(
          activity <- activity %>%
            add_row(
              book_id = data$Book.Id[i],
              date = input[[paste0("date_read_", data$Book.Id[i])]],
              no_of_pages = input[[paste0("pages_read_", data$Book.Id[i])]]
            )
        )

        output[[paste0("activity_grid_", data$Book.Id[i])]] <- render_activity_grid(data[i, ], activity)

        cache[["activity"]] <<- activity
        removeModal()
        isolate(reactive_activity(activity))
      })
    })

    ### 2309 Observe Save ---------------------------------------------------------------------------------------------
    observeEvent(input[["save"]], {
      sheet_write(
        cache$data,
        ss = sheet_id,
        sheet = "data"
      )

      sheet_write(
        cache$activity,
        ss = sheet_id,
        sheet = "activity"
      )
    })

    ### 2310 Observe Add Book -----------------------------------------------------------------------------------------
    observeEvent(input[["add_book"]], {
      temp_book <- reactive_temp_book()
      showModal(modalDialog(
        title = tagList(
          "Enter Book Detials",
          actionButton("load_data", "Load Data from Link",
            class = "btn btn-primary",
            style = "position: absolute; right: 20px; top: 10px;"
          )
        ),
        #### 2310.01 Book.Id ------------------------------------------------------------------------------------------
        textInput(
          input = "Book.Id",
          label = "Book ID:",
          value = temp_book$Book.Id
        ),
        #### 2310.02 Title --------------------------------------------------------------------------------------------
        textInput(
          input = "Title",
          label = "Title:",
          value = temp_book$Title
        ),
        #### 2310.03 Author -------------------------------------------------------------------------------------------
        textInput(
          input = "Author",
          label = "Author:",
          value = temp_book$Author
        ),
        #### 2310.04 ISBN -------------------------------------------------------------------------------------------
        textInput(
          input = "ISBN",
          label = "ISBN:",
          value = temp_book$ISBN
        ),
        #### 2310.5 Number.of.Pages -------------------------------------------------------------------------------------------
        textInput(
          input = "Number.of.Pages",
          label = "Page Count:",
          value = temp_book$Number.of.Pages
        ),
        #### 2310.6 Year.of.Publication -------------------------------------------------------------------------------------------
        textInput(
          input = "Original.Publication.Year",
          label = "Year of Publication:",
          value = temp_book$Original.Publication.Year
        ),
        #### 2310.7 Cover_URL -------------------------------------------------------------------------------------------
        textInput(
          input = "Cover_URL",
          label = "Cover Path:",
          value = temp_book$Cover_URL
        ),
        #### 2310.8 Bookshelves -------------------------------------------------------------------------------------------
        div(
          class = "dark-select",
          selectInput(
            inputId = "Bookshelves",
            label = "Shelf:",
            choices = c(
              "Currently Reading" = "currently-reading",
              "Want To Read" = "to-read",
              "Read" = "read",
              "Did Not Finish" = "did-not-finish"
            ),
            selected = temp_book$Bookshelves # Default shelf (if provided in the book data)
          )
        ),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("save_add_book", "Save")
        )
      ))
    })

    # Observe the load data button in the first modal
    observeEvent(input$load_data, {
      showModal(
        modalDialog(
          title = "Enter Data Link",
          textInput("data_link", "Data Link:", placeholder = "Enter URL or identifier"),
          footer = tagList(
            modalButton("Cancel"),
            actionButton("submit_link", "Load Data")
          )
        )
      )
    })

    observeEvent(input$submit_link, {
      # Remove the link entry modal
      removeModal()

      # Here you would typically fetch data from the link
      # For this example, we'll just use some sample data
      if (nzchar(input$data_link)) {
        # Simulate loading data from a link
        # In a real app, you might use httr or similar to fetch data
        sample_data <- paste("Data from", input$data_link)

        # Update the reactive values with sample data
        temp_book$Book.Id <- scrape_book_id(input$data_link)
        temp_book$Title <- scrape_title(input$data_link)
        temp_book$Author <- scrape_author(input$data_link)
        temp_book$ISBN <- scrape_isbn(input$data_link)
        temp_book$No.of.Pages <- scrape_page_count(input$data_link)
        temp_book$Original.Publication.Year <- scrape_publication_year(input$data_link)
        temp_book$Cover_URL <- scrape_cover_url(input$data_link)

        reactive_temp_book(temp_book)

        # Show the main modal again with populated data
        showModal(modalDialog(
          title = tagList(
            "Enter Book Detials",
            actionButton("load_data", "Load Data from Link",
              class = "btn btn-primary",
              style = "position: absolute; right: 20px; top: 10px;"
            )
          ),
          #### 2310.01 Book.Id ----------------------------------------------------------------------------------------
          textInput(
            input = "Book.Id",
            label = "Book ID:",
            value = temp_book$Book.Id
          ),
          #### 2310.02 Title ------------------------------------------------------------------------------------------
          textInput(
            input = "Title",
            label = "Title:",
            value = temp_book$Title
          ),
          #### 2310.03 Author -----------------------------------------------------------------------------------------
          textInput(
            input = "Author",
            label = "Author:",
            value = temp_book$Author
          ),
          #### 2310.04 ISBN -------------------------------------------------------------------------------------------
          textInput(
            input = "ISBN",
            label = "ISBN:",
            value = temp_book$ISBN
          ),
          #### 2310.5 Number.of.Pages ---------------------------------------------------------------------------------
          textInput(
            input = "Number.of.Pages",
            label = "Page Count:",
            value = temp_book$Number.of.Pages
          ),
          #### 2310.6 Year.of.Publication -----------------------------------------------------------------------------
          textInput(
            input = "Original.Publication.Year",
            label = "Year of Publication:",
            value = temp_book$Original.Publication.Year
          ),
          #### 2310.7 Cover_URL ---------------------------------------------------------------------------------------
          textInput(
            input = "Cover_URL",
            label = "Cover Path:",
            value = temp_book$Cover_URL
          ),
          #### 2310.8 Bookshelves -------------------------------------------------------------------------------------
          textInput(
            input = "Bookshelves",
            label = "Shelf:",
            value = temp_book$Bookshelves
          ),
          footer = tagList(
            modalButton("Cancel"),
            actionButton("save_add_book", "Save")
          )
        ))
      }
    })

    observeEvent(input$save_add_book, {
      data <- reactive_data()

      # Update reactive values with current inputs
      temp_book$Book.Id <- input$Book.Id
      temp_book$Title <- input$Title
      temp_book$Author <- input$Author
      temp_book$ISBN <- input$ISBN
      temp_book$Number.of.Pages <- input$Number.of.Pages
      temp_book$Original.Publication.Year <- input$Original.Publication.Year
      temp_book$Cover_URL <- input$Cover_URL
      temp_book$Bookshelves <- input$Bookshelves

      temp_book_df <- data.frame(temp_book)
      data <- data %>%
        add_row(temp_book_df)

      reactive_data(data)


      print(reactive_temp_book)

      # Remove the modal
      removeModal()
    })
  })

  ## 240 Save on Stop -------------------------------------------------------------------------------------------------
  onStop(
    function() {
      sheet_write(
        cache$data,
        ss = sheet_id,
        sheet = "data"
      )

      sheet_write(
        cache$activity,
        ss = sheet_id,
        sheet = "activity"
      )
    }
  )
}

# 300 Run App ---------------------------------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)
