get_activity_data <- function(
    use_cache = getOption("books_cache"),
    activity_file_path = getOption("activity_file_path")) {
  if (use_cache) {
    read_rds("data/output/cache.rds")$activity
  } else {
    activity_data <- data.frame(
      book_id = c(),
      date = c(),
      no_of_pages = c()
    )
  }
}
