library(epubr)
library(tidyverse)
library(rvest)
library(shiny)
library(dplyr)
library(shinyWidgets)
library(shinyjs)

# Set Options ------------------------------------------------------------------
options(log_verbose = TRUE)
options(r_functions_path = "R/functions")

# Source functions -------------------------------------------------------------
source("R/functions/source_functions.R")
source_functions()

# Set Global Variables ---------------------------------------------------------
goodreads_file_path <- "data/input/goodreads_data.csv"
