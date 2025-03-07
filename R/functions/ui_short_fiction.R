ui_short_fiction <- function() {
  tabPanel(
    "Short Fiction",
    h3("Short Fiction"),
    div(id = "short-fiction", uiOutput("short_fiction_ui"))
  )
}
