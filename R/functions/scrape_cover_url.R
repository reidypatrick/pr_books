scrape_cover_url <- function(html) {
  html %>% 
    html_element(css = "div.BookCover img") %>%
    html_attr("src")
}
