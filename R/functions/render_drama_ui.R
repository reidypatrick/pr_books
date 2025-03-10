render_drama_ui <- function(.data) {
  .drama <- filter_drama(.data)
  renderUI({
    if (nrow(.drama) > 0) {
      lapply(seq_len(nrow(.drama)), function(i) {
        generate_poetry_container(.drama[i, ], i)
      })
    } else {
      p("No books currently being read.")
    }
  })
}
