sheet_id <- drive_get("pr_books/cache")

goodreads_data <- read_sheet(
  ss = sheet_id,
  sheet = "data"
) %>%
  unique() 

sheet_write(
  goodreads_data,
  ss = sheet_id,
  sheet = "data"
)
