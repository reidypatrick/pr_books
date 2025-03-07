render_short_fiction_ui <- function(.short_fiction) {
  renderUI({
    if (nrow(.short_fiction) > 0) {
      lapply(seq_len(nrow(.short_fiction)), function(i) {
        generate_poetry_container(.short_fiction[i, ], i)
      })
    } else {
      p("No books currently being read.")
    }
  })
}
