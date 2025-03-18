observe_shelves <- function(i) {
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
}
