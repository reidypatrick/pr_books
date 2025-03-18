activity_data <- data.frame(
  book_id = c(1953, 12505),
  date =   c(as.Date("2025-03-11"), as.Date("2025-03-11")),
  no_of_pages = c(44, 16)
)

write_csv(activity_data, "data/output/activity_cache.csv")

activity_data


data
