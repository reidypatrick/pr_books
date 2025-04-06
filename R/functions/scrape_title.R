scrape_title <- function(html) {
  html %>% 
    html_element(css = "div.BookPageTitleSection__title") %>% 
    html_text2()
}