filter_novels <- function(.data) {
  .data %>%
    mutate(Bookshelves = ifelse(is.na(Bookshelves), "read", Bookshelves)) %>%
    filter(Bookshelves %in% c("currently-reading", "to-read", "read", "did-not-finish"))
}
