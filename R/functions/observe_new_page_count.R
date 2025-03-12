observe_new_page_count <- function(data, input, output) {
  lapply(seq_along(data$Book.Id), function(i) {
    observeEvent(input[[paste0("submit_page_count_", data$Book.Id[i])]], {
      data <- reactive_data()
      data$Number.of.Pages[i] <- input[[paste0("page_count_", data$Book.Id[i])]]
      reactive_data(data)
      cache <<- data
      removeModal()
    })
  })
}
