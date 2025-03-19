library(googledrive)
library(googlesheets4)

drive_auth()

drive_mkdir("pr_books")
drive_upload("data/output/cache.rds", "pr_books/")

sheet_id <- drive_get("pr_books/cache")$id

sheet_write(
  data = cache$data,
  ss = sheet_id,
  sheet = "data"
)

sheet_write(
  data = cache$activity,
  ss = sheet_id,
  sheet = "activity"
)
