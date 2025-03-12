render_activity_grid <- function(data) {
  renderUI({
    # Group data by week
    weeks <- split(data, data$week)

    # Create y-axis labels for Mon, Wed, Fri
    y_axis_labels <- div(
      class = "y-axis-labels",
      lapply(levels(data$day), function(day) {
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
            levels(data$day), function(day) { # Use levels(data$day) to maintain order
              # Filter data for the current day
              day_data <- week_data[week_data$day == day, ]
              # Create a cell for the day (if data exists)
              if (nrow(day_data) > 0) {
                value <- day_data$value[1]
                date <- day_data$date[1]
                # Map value to a color gradient
                color <- rgb(
                  red = 33, 
                  green = min(100 + (value * 5), 255),  # Increase green based on value
                  blue = 57, 
                  maxColorValue = 255, 
                  alpha = value * 25  # Adjust alpha based on value
                )
                # Add a tooltip with the date and value
                div(
                  class = "activity-cell",
                  style = paste0("background-color: ", color, ";"),
                  title = paste("Date:", date, "\nValue:", value) # Tooltip content
                )
              } else {
                # Add an empty cell if no data exists for this day in the week
                div(class = "activity-cell", style = "background-color: #ebedf0;")
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
