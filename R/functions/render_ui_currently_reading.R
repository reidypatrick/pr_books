render_ui_currently_reading <- function(currently_reading) {
  renderUI({
    if (nrow(currently_reading) > 0) {
      lapply(seq_len(nrow(currently_reading)), function(i) {
        generate_novel_container(currently_reading[i, ], i)
      })
    } else {
      p("No books currently being read.")
    }
  })
}
