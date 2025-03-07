filter_poetry <- function(.data) {
  .data %>%
    filter(Bookshelves %in% c("poetry", "poetry-want-to-read"))
}
