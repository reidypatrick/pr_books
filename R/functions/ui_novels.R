ui_novels <- function() {
  tabPanel(
    "Novels",
    h3("Novels"),
    actionButton("toggle_currently_reading", "Currently Reading"),
    hidden(div(id = "currently_reading_section", uiOutput("currently_reading_ui"))),
    actionButton("toggle_read", "Read"),
    hidden(div(id = "read_section", uiOutput("read_ui"))),
    actionButton("toggle_want_to_read", "Want to Read"),
    hidden(div(id = "want_to_read_section", uiOutput("want_to_read_ui"))),
    actionButton("toggle_did_not_finish", "Did Not Finish"),
    hidden(div(id = "did_not_finish_section", uiOutput("did_not_finish_ui")))
  )
}
