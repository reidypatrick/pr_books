get_temp_activity_data <- function() {
  dates <- seq(Sys.Date() - days(84), Sys.Date(), by = "day")
  values <- sample(0:10, length(dates), replace = TRUE)
  data <- data.frame(date = dates, value = values) %>%
    mutate( # get weeks from today
      week = as.numeric(floor(difftime(today(), date, units = "weeks")))
    ) %>%
    mutate( # set day as factor
      day = factor(
        weekdays(date),
        levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
      )
    ) %>%
    mutate( # account for day of week
      week = ifelse(
        as.numeric(day) > which(levels(day) == weekdays(today())),
        week + 1,
        week
      )
    )
}
