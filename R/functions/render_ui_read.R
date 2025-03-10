render_ui_novels_read <- function(.data) {
  #TODO sort by read date
  renderUI({
    read <- .data %>% filter(Bookshelves == "read")
    if (nrow(read) > 0) {
      lapply(seq_len(nrow(read)), function(i) {
        generate_book_container(read[i, ], i)
      })
    } else {
      p("Finsished Books will appear here.")
    }
  })
}
