ui_poetry <- function() {
  tabPanel(
    "Poetry",
    h3("Poetry"),
    div(id = "poetry", uiOutput("poetry_ui"))
  )
}
