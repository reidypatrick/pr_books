render_non_fiction_ui <- function(.non_fiction) {
  renderUI({
    if (nrow(.non_fiction) > 0) {
      lapply(seq_len(nrow(.non_fiction)), function(i) {
        generate_poetry_container(.non_fiction[i, ], i)
      })
    } else {
      p("No books currently being read.")
    }
  })
}
