filter_non_fiction <- function(.data) {
  .data %>%
    filter(Bookshelves %in% c("non-fiction", "non-fiction-want-to-read"))
}
