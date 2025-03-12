observe_edit_page_count <- function(data, input, output) {
  lapply(seq_along(data$Book.Id), function(i) {
    observeEvent(input[[paste0("show_numeric_dialog_", data$Book.Id[i])]], {
      showModal(modalDialog(
        title = "Edit Page Count",
        numericInput(
          inputId = paste0("page_count_", data$Book.Id[i]),
          label = "Page Count",
          value = 0
        ),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(
            input = paste0("submit_page_count_", data$Book.Id[i]),
            label = "Submit"
          )
        )
      ))
    })
  })
}
