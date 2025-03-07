generate_novel_container <- function(book, index) {
  div(
    class = "book-container",
    fluidRow(
      column(
        4,
        div(
          class = "book-cover",
          img(
            src = book$Cover_URL,
            alt = "Book Cover",
            height = "200px",
            width = "auto"
          )
        )
      ),
      column(
        8,
        div(
          class = "book-details",
          h4(class = "book-title", book$Title),
          p(class = "book-author", paste("Author:", book$Author)),
          p(class = "book-year", paste("Year of Publication:", book$Original.Publication.Year)),
          p(paste("Total Pages:", book$Number.of.Pages)),
          numericInput(
            inputId = paste0("current_page_", index),
            label = "Current Page:",
            value = 0, # Default to 0
            min = 0,
            step = 1
          ),
          div(
            class = "progress-bar-container",
            uiOutput(paste0("reading_progress_", index))
          )
        )
      )
    )
  )
}
