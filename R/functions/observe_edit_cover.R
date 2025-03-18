observe_edit_cover <- function(data, input, output) {
  lapply(seq_along(data$Book.Id), function(i) {
    observeEvent(input[[paste0("show_text_dialog_", data$Book.Id[i])]], {
      showModal(modalDialog(
        title = "Enter Text",
        textInput(
          inputId = paste0("cover_url_", data$Book.Id[i]),
          label = "Cover URL"
        ),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(
            input = paste0("submit_cover_url_", data$Book.Id[i]),
            label = "Submit"
          )
        )
      ))
    })
  })
}
