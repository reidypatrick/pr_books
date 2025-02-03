# Function to create a basic README file
create_readme <- function(
  file_name = "README.md",
  proj_name = sub(".*/([^/]+)$", "\\1", rstudioapi::getActiveProject()),
  description = "Project description goes here."
) {

  # Define the content of the README
  lintr_badge_yml <- paste0(
    "[![lint-project](https://github.com/reidypatrick/",
    proj_name,
    "/actions/workflows/lint-project.yaml/badge.svg)](https://github.com/reidypatrick/",
    proj_name,
    "/actions/workflows/lint-project.yaml)"
  )

  content <- c(
    lintr_badge_yml,
    "",

    paste0("# ", proj_name),

    "",
    "## Description",
    description
  )

  # Write content to the README.md file
  writeLines(content, con = file_name)

  cat("README file created successfully: ", file_name, "\n")
}
