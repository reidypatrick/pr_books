scrape_page_count <- function(html) {
  html %>%
    html_element("div.FeaturedDetails") %>%
    html_text2() %>% 
    str_extract("[^ ]+")
}
