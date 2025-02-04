get_goodreads_cover <- function(goodreads_book_id) {
  goodreads_url <- paste("https://www.goodreads.com/book/show/", goodreads_book_id, sep = "")
  
  goodreads_page <- read_html(goodreads_url)
  
  goodreads_cover <- goodreads_page %>%
    html_element(css = "div.BookCover img") %>%
    html_attr("src")
}