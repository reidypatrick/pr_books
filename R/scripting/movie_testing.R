# Set up rvest connections --------------------------------------------------------------------------------------------
letterboxd_data <- read_csv("data/input/letterboxd_data.csv")

letterboxd_url <- letterboxd_data$`Letterboxd URI`[1]

letterboxd_page <- rvest::read_html(letterboxd_url)

# Get Director --------------------------------------------------------------------------------------------------------
letterboxd_director <- letterboxd_page %>%
  html_element(css = "span.directorlist") %>%
  html_text2()

letterboxd_director[1]

# Get Country ---------------------------------------------------------------------------------------------------------
letterboxd_country <- letterboxd_page %>%
  html_elements(css = "div#tab-details.tabbed-content-block.column-block") %>%
  html_text2() %>%
  str_split("\n\n") %>%
  unlist()

letterboxd_country[[which(letterboxd_country == "Country") + 1]]
