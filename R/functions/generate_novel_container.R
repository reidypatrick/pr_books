generate_novel_container <- function(book) {
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
            inputId = paste0("current_page_", book$Book.Id),
            label = "Current Page:",
            value = book$Current.Page, # Default to 0
            min = 0,
            step = 1
          ),
          selectInput(
            inputId = paste0("shelf_", book$Book.Id),
            label = "Shelf:",
            choices = c(
              "Currently Reading" = "currently-reading",
              "Want To Read" = "to-read",
              "Read" = "read",
              "Did Not Finish" = "did-not-finish"
            ),
            selected = book$Bookshelves # Default shelf (if provided in the book data)
          ),
          div(
            class = "progress-bar-container",
            uiOutput(paste0("reading_progress_", book$Book.Id))
          )
        )
      )
    )
  )
}