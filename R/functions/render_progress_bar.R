render_progress_bar <- function(input, book, index) {
  renderUI({
    # Get total pages from the dataset
    total_pages <- book$Number.of.Pages
    
    # Get current page input, defaulting to 0 if empty or invalid
    current_page <- tryCatch(
      {
        as.numeric(input[[paste0("current_page_", index)]])
      },
      error = function(e) {
        0
      }
    )
    
    # Ensure current_page is valid
    if (is.na(current_page)) {
      current_page <- 0
    } else {
      # Calculate progress
      progress_value <- round((current_page / total_pages) * 100)
      
      # Ensure progress_value is within 0-100
      progress_value <- max(0, min(100, progress_value))
      
      # Render progress bar
      progressBar(
        id = paste0("progress_", index),
        value = progress_value,
        total = 100,
        display_pct = TRUE
      )
    }
  })
}