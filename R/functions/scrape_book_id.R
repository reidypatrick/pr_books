scrape_book_id <- function(url) {
  sub("^.*/(.*)$", "\\1", url)
}
