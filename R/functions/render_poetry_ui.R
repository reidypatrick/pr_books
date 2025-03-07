render_poetry_ui <- function(.poetry) {
  renderUI({
    if (nrow(.poetry) > 0) {
      lapply(seq_len(nrow(.poetry)), function(i) {
        generate_poetry_container(.poetry[i, ], i)
      })
    } else {
      p("No books currently being read.")
    }
  })
}
