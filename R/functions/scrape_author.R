scrape_author <- function(html) {
  html %>%
    html_element("div.BookPageMetadataSection__contributor") %>%
    html_text2()
}
