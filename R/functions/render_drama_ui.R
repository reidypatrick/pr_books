render_drama_ui <- function(.drama) {
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
