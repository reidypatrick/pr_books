render_ui_novels_did_not_finish_ui <- function(.novels) {
  
  renderUI({
    did_not_finsih <- .novels %>% filter(Bookshelves == "did_not_finish")
    if (nrow(did_not_finsih) > 0) {
      lapply(seq_len(nrow(did_not_finish)), function(i) {
        generate_book_container(did_not_finish[i, ], i)
      })
    } else {
      p("Books you did not finish will appear here")
    }
  })
}
