filter_short_fiction <- function(.data) {
  .data %>%
    filter(Bookshelves %in% c("short-fiction", "short-fiction-want-to-read"))
}
