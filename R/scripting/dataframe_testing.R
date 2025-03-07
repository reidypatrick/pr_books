goodreads_data <- get_goodreads_data() %>%
  mutate(Current.Page = rep(NA, nrow(.)))
