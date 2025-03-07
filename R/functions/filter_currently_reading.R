filter_currently_reading <- function(novels) {
  novels %>% 
    filter(Bookshelves == "currently-reading")
}