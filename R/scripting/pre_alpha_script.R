source("R/scripting/config.R")

cols <- c("id", "img_cover", "title", "author", "published")

file <- "data/epub/Hemingway, Ernest - Men Without Women.epub"

epub(file)$data
