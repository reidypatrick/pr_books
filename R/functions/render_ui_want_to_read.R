render_ui_want_to_read <- function(.data) {
  # TODO: Sort by preference
  renderUI({
    want_to_read <- .data %>% filter(Bookshelves == "to-read")
    if (nrow(want_to_read) > 0) {
      lapply(seq_len(nrow(want_to_read)), function(i) {
        generate_book_container(want_to_read[i, ])
      })
    } else {
      p("Add books that you want to read.")
    }
  })
}
