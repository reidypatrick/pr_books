get_goodreads_data <- function(use_cache = FALSE) {
  if (use_cache & exists("cache")) {
    goodreads_data <- cache
  } else {
    read_csv(goodreads_file_path) %>%
      mutate(Current.Page = rep(0, nrow(.))) %>%
      relocate(Current.Page, .after = Number.of.Pages) %>%
      mutate(Bookshelves = ifelse(is.na(Bookshelves), "read", Bookshelves))
  }
}
