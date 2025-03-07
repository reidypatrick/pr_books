filter_drama <- function(.data) {
  .data %>% 
    filter(Bookshelves %in% c("drama", "drama-want-to-read"))
}