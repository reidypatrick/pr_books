render_activity_grid <- function(book, activity) {
  renderUI({
    # Group data by week
    book_activity <- filter(activity, book_id == book$Book.Id) %>%
      group_by(date) %>%
      summarise(no_of_pages = sum(no_of_pages))

    dates <- seq(Sys.Date() - days(161), Sys.Date(), by = "day")


    book_data <- as.data.frame(dates) %>%
      left_join(book_activity, join_by(x$dates == y$date)) %>%
      mutate(no_of_pages = ifelse(is.na(no_of_pages), 0, no_of_pages)) %>%
      mutate( # get weeks from today
        week = as.numeric(floor(difftime(today(), dates, units = "weeks")))
      ) %>%
      mutate( # set day as factor
        day = factor(
          weekdays(dates),
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

    weeks <- split(book_data, book_data$week)

    # Create y-axis labels for Mon, Wed, Fri
    y_axis_labels <- div(
      class = "y-axis-labels",
      lapply(levels(book_data$day), function(day) {
        if (day == "Monday") {
          div(class = "y-axis-label", "Mon")
        } else if (day == "Wednesday") {
          div(class = "y-axis-label", "Wed")
        } else if (day == "Friday") {
          div(class = "y-axis-label", "Fri")
        } else {
          div(class = "y-axis-label", "") # Empty label for other days
        }
      })
    )

    # Create the activity grid
    activity_grid <- div(
      class = "activity-grid",
      lapply(names(weeks), function(week) {
        week_data <- weeks[[week]]
        # Create a column for the week
        div(
          class = "activity-column",
          lapply(
            levels(book_data$day), function(day) { # Use levels(data$day) to maintain order
              # Filter data for the current day
              day_data <- week_data[week_data$day == day, ]
              # Create a cell for the day (if data exists)
              if (nrow(day_data) > 0) {
                no_of_pages <- day_data$no_of_pages[1]
                date <- day_data$date[1]
                # Map no_of_pages to a color gradient
                if (no_of_pages != 0) {
                  color <- rgb(
                    red = 33,
                    green = min(100 + (no_of_pages * 5), 255), # Increase green based on no_of_pages
                    blue = 57,
                    maxColorValue = 255,
                    alpha = min(no_of_pages * 25, 255) # Adjust alpha based on no_of_pages
                  )
                  # Add a tooltip with the date and no_of_pages
                  div(
                    class = "activity-cell",
                    style = paste0("background-color: ", color, ";"),
                    title = paste("Date:", date, "\nPages:", no_of_pages) # Tooltip content
                  )
                } else {
                  div(
                    class = "activity-cell",
                    style = paste0("background-color: #121212;"),
                    title = paste("Date:", date, "\nPages:", no_of_pages) # Tooltip content
                  )
                }
              } else {
                # Add an empty cell if no data exists for this day in the week
                div(class = "activity-cell", style = "background-color: #1e1e1e;")
              }
            }
          )
        )
      })
    )

    # Combine y-axis labels and activity grid
    div(
      class = "activity-container",
      y_axis_labels,
      activity_grid
    )
  })
}
