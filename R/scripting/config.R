library(epubr)
library(tidyverse)
library(rvest)
library(shiny)
library(dplyr)
library(shinyWidgets)
library(shinyjs)
library(readr)
library(googledrive)

# Set Options ---------------------------------------------------------------------------------------------------------
options(log_verbose = TRUE)
options(r_functions_path = "R/functions")
options(books_cache = TRUE)

# Source functions ----------------------------------------------------------------------------------------------------
source("R/functions/source_functions.R")
source_functions()

# Set File Paths ------------------------------------------------------------------------------------------------------
options(goodreads_file_path = "data/output/cache_data.csv")
options(activity_file_path = "data/output/cache_activity.csv")

# Set up google drive connection --------------------------------------------------------------------------------------
options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = ".secrets"
)
