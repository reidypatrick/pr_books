get_goodreads_data <- function(
    use_cache = getOption("books_cache"),
    path = getOption("goodreads_file_path")) {
  if (use_cache) {
    goodreads_data <- read_rds("data/output/cache.rds")$data
  } else {
    read_csv(goodreads_file_path) %>%
      mutate(Current.Page = rep(0, nrow(.))) %>%
      relocate(Current.Page, .after = Number.of.Pages) %>%
      mutate(Bookshelves = ifelse(is.na(Bookshelves), "read", Bookshelves))
  }
}
