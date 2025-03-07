ui_novels_read_ui <- function(.novels) {
  renderUI({
    read <- .novels %>% filter(Bookshelves == "read")
    if (nrow(read) > 0) {
      lapply(seq_len(nrow(read)), function(i) {
        generate_book_container(read[i, ], i)
      })
    } else {
      p("Finsished Books will appear here.")
    }
  })
}
