ui_novels <- function() {
  tabPanel(
    "Novels",
    tabsetPanel(
      tabPanel(
        "Currently Reading",
        div(id = "currently_reading_section", uiOutput("currently_reading_ui"))
      ),
      tabPanel(
        "Read",
        div(id = "read_section", uiOutput("read_ui"))
      ),
      tabPanel(
        "Want to Read",
        div(id = "want_to_readsection", uiOutput("want_to_read_ui"))
      ),
      tabPanel(
        "Did Not Finish",
        div(id = "did_not_finish_section", uiOutput("did_not_finish_ui"))
      )
    )
  )
}
