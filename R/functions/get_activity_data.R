get_activity_data <- function(
    use_cache = getOption("books_cache"),
    activity_file_path = "data/output/activity_data.csv") {
  if (use_cache) {
    read_csv(activity_file_path)
  } else {
    activity_data <- data.frame(
      book_id = c(),
      date = c(),
      no_of_pages = c()
    )
  }
}
