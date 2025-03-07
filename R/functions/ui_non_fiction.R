ui_non_fiction <- function() {
  tabPanel(
    "Non-Fiction",
    h3("Non-Fiction"),
    div(id = "non-fiction", uiOutput("non_fiction_ui"))
  )
}
