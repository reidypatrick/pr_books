get_goodreads_cover_df <- function(.data) {
  goodreads_url <- paste("https://www.goodreads.com/book/show/", .data$`Book Id`, sep = "")
  
  goodreads_page <- read_html(goodreads_url)
  
  goodreads_cover <- goodreads_page %>%
    html_element(css = "div.BookCover img") %>%
    html_attr("src")
}
