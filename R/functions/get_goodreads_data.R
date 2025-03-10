get_goodreads_data <- function() {
  read_csv(goodreads_file_path) %>%
    mutate(Current.Page = rep(0, nrow(.))) %>%
    relocate(Current.Page, .after = Number.of.Pages) %>% 
    mutate(Bookshelves = ifelse(is.na(Bookshelves), "read", Bookshelves))
}
