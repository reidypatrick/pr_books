observe_new_cover <- function(data, input, output) {
  lapply(seq_along(data$Book.Id), function(i) {
    observeEvent(input[[paste0("submit_cover_url_", data$Book.Id[i])]], {
      data <- reactive_data()
      data$Cover_URL[i] <- input[[paste0("cover_url_", data$Book.Id[i])]]
      reactive_data(data)
      cache <<- data
      removeModal()
    })
  })
}
