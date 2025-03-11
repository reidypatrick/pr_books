hardcover_url <- "https://hardcover.app/@sackless/books"

hardcover_page <- read_html(hardcover_url)

hardcover_cover <- hardcover_page %>%
  html_elements(css = "div.w-full.p-4.bg-card.rounded.my-20.flex.flex-col") %>%
  html_elements(css = "div.relative.overflow-hidden.group.transition-all.relative img") %>%
  html_attr("src")


hardcover_cover

"div.w-full.p-4.bg-card.rounded.my-20.flex.flex-col"
