source("R/scripting/config.R")

# Load Goodreads data
goodreads_data <- get_goodreads_data()



Cover_URL <- rep(NA, nrow(goodreads_data))
for (i in seq_len(nrow(goodreads_data))) {
  goodreads_url <- paste("https://www.goodreads.com/book/show/", goodreads_data$Book.Id[i], sep = "")

  goodreads_page <- read_html(goodreads_url)

  goodreads_cover <- goodreads_page %>%
    html_element(css = "div.BookCover img") %>%
    html_attr("src")

  Cover_URL[i] <- goodreads_cover
}



goodreads_data <- data.frame(goodreads_data, Cover_URL)

write_csv(goodreads_data, file = "data/input/goodreads_data.csv")


goodreads_data <- goodreads_data %>%
  mutate(Cover_URL = Cover_URL.1) %>%
  select(-Cover_URL.1)
