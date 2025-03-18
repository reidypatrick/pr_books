observe_progress_bars <- function(data, input, output) {
  lapply(seq_along(data$Book.Id), function(i) {
    observeEvent(input[[paste0("current_page_", data$Book.Id[i])]], {
      data <- reactive_data()
      data$Current.Page[i] <- input[[paste0("current_page_", data$Book.Id[i])]]
      reactive_data(data)
      output[[paste0("reading_progress_", data$Book.Id[i])]] <- render_progress_bar(data[i, ])
      cache <<- data
    })
  })
}
