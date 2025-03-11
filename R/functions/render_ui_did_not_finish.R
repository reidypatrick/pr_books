render_ui_did_not_finish <- function(.data) {
  renderUI({
    did_not_finish <- .data %>% filter(Bookshelves == "did-not-finish")
    if (nrow(did_not_finish) > 0) {
      lapply(seq_len(nrow(did_not_finish)), function(i) {
        generate_book_container(did_not_finish[i, ])
      })
    } else {
      p("Books you did not finish will appear here")
    }
  })
}
