scrape_publication_year <- function(html) {
  html %>%
    html_element("div.FeaturedDetails") %>%
    html_text2() %>% 
    str_extract("[^ ]+$")
}