# Install and load necessary packages
library(shiny)
library(htmltools)
library(lubridate)

# Define UI
ui <- fluidPage(
  # Add custom CSS for styling
  tags$head(
    tags$style(HTML("
      .activity-container {
        display: flex;
        flex-direction: row;
        gap: 10px;
      }
      .y-axis-labels {
        display: flex;
        flex-direction: column;
        gap: 0px;
        justify-content: space-between;
        padding-top: 0px;  /* Align labels with cells */
      }
      .y-axis-label {
        height: 15px;
        text-align: right;
        padding-right: 5px;
        font-size: 12px;
      }
      .activity-grid {
        display: flex;
        flex-direction: row;
        gap: 2px;
      }
      .activity-column {
        display: flex;
        flex-direction: column;
        gap: 2px;
      }
      .activity-cell {
        width: 15px;
        height: 15px;
        background-color: #ebedf0;
        border-radius: 3px;
      }
      .activity-cell:hover {
        border: 1px solid black;
      }
    "))
  ),
  titlePanel("GitHub-like Activity Graph with Sunday at the Top"),
  mainPanel(
    # Output the activity grid
    uiOutput("activity_grid")
  )
)

# Define server logic
server <- function(input, output, session) {
  # Generate sample data
  set.seed(123)
  dates <- seq(Sys.Date() - days(182), Sys.Date(), by = "day")
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

  # Create the activity grid
  output$activity_grid <- renderUI({
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
                color <- rgb(33, 110, 57, maxColorValue = 255, alpha = value * 25)
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

# Run the Shiny app
shinyApp(ui, server)
