render_ui_did_not_finish <- function(.data) {
  renderUI({
    did_not_finsih <- .data %>% filter(Bookshelves == "did_not_finish")
    if (nrow(did_not_finsih) > 0) {
      lapply(seq_len(nrow(did_not_finish)), function(i) {
        generate_book_container(did_not_finish[i, ], i)
      })
    } else {
      p("Books you did not finish will appear here")
    }
  })
}
