ui_novels_currently_reading <- function(.novels) {
  renderUI({
    currently_reading <- .novels %>% filter(Bookshelves == "currently-reading")
    if (nrow(currently_reading) > 0) {
      lapply(seq_len(nrow(currently_reading)), function(i) {
        generate_book_container(currently_reading[i, ], i)
      })
    } else {
      p("No books currently being read.")
    }
  })
}