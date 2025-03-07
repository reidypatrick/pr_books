update_current_page <- function(.data, .title, .input, page_no) {
  .data %>%
    mutate(Current.Page = ifelse(Title = .title, page_no, Current.Page))
}
