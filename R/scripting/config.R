library(epubr)
library(tidyverse)
library(rvest)

# Source functions -------------------------------------------------------------
source("R/functions/source_functions.R")
source_functions()

# Set Options ------------------------------------------------------------------
options(log_verbose = TRUE)
options(r_functions_path = "R/functions")

# Set Global Variables ---------------------------------------------------------
goodreads_file_path <- "data/input/goodreads_library_export.csv"
