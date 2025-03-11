library(epubr)

goodreads_data <- get_goodreads_data() %>%
  mutate(Current.Page = rep(NA, nrow(.)))



goodreads_data <- get_goodreads_data()
novels <- filter_novels(goodreads_data)
currently_reading <- filter_currently_reading(novels)
poetry <- filter_poetry(goodreads_data)
short_fiction <- filter_short_fiction(goodreads_data)
drama <- filter_drama(goodreads_data)
non_fiction <- filter_non_fiction(goodreads_data)

list.files("data/epub")

murakami_1 <- epub("data/epub/Murakami, Haruki - Men Without Women_ Stories.epub")$data[[1]] %>%
  filter(section == "inlinetoc")

hemingway_1 <- epub("data/epub/HEMINGWAY.epub")$data[[1]] %>%
  filter(section == "id1110")


cat(hemingway_1$text)

cat(book_toc$text)


short_fiction
