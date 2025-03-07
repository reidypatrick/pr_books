ui_novels_want_to_read <- function(.novels) {
  # TODO: Sort by preference
  renderUI({
    want_to_read <- .novels %>% filter(Bookshelves == "to-read")
    if (nrow(want_to_read) > 0) {
      lapply(seq_len(nrow(want_to_read)), function(i) {
        generate_book_container(want_to_read[i, ], i)
      })
    } else {
      p("Add books that you want to read.")
    }
  })
}
