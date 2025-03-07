ui_drama <- function() {
  tabPanel(
    "Drama",
    h3("Drama"),
    div(id = "drama", uiOutput("drama_ui"))
  )
}