scrape_cover_url <- function(url) {
  paste0(
    "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1436934349i/",
    temp_book$Book.Id,
    ".jpg",
    sep = ""
  )
}
