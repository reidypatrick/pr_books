library(epubr)
library(tidyverse)
library(rvest)
library(shiny)
library(dplyr)
library(shinyWidgets)
library(shinyjs)
library(readr)

# Set Options ------------------------------------------------------------------
options(log_verbose = TRUE)
options(r_functions_path = "R/functions")
options(books_cache = FALSE)

# Source functions -------------------------------------------------------------
source("R/functions/source_functions.R")
source_functions()

# Set Global Variables ---------------------------------------------------------
goodreads_file_path <- "data/input/goodreads_data.csv"
