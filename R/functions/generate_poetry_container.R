generate_poetry_container <- function(book, index) {
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
          p(paste("Total Pages:", book$Number.of.Pages))
        )
      )
    )
  )
}