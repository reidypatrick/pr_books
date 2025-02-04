source("R/scripting/config.R")

cols <- c("id", "img_cover", "title", "author", "published")

file <- "data/epub/Hemingway, Ernest - Men Without Women.epub"

epub(file)$data

# csv testing ------------------------------------------------------------------
goodreads_data <- read_csv("data/input/goodreads_library_export.csv")

goodreads_url <- paste("https://www.goodreads.com/book/show/", goodreads_data$`Book Id`[1], sep = "")

goodreads_page <- read_html(goodreads_url)

goodreads_cover <- goodreads_page %>%
  html_element(css = "div.BookCover img") %>%
  html_attr("src")
