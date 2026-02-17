test_that("make_filename creates correct strings", {
  expect_equal(make_filename(2013), "accident_2013.csv.bz2")
  expect_equal(make_filename("2014"), "accident_2014.csv.bz2")
})

test_that("fars_read throws error for missing files", {
  expect_error(fars_read("non_existent_file.csv"))
})

test_that("fars_summarize_years returns a data frame/tibble", {
  # We use a temp path to the sample data you added to inst/extdata
  file_path <- system.file("extdata", "accident_2013.csv.bz2", package = "fars")

  # Skip if the file isn't found (prevents test failure if data is missing)
  skip_if(file_path == "")

  # Check if the output is a data frame
  summary_data <- fars_summarize_years(2013)
  expect_s3_class(summary_data, "data.frame")
})

test_that("fars_map_state errors on invalid state", {
  expect_error(fars_map_state(99, 2013))
})

test_that("fars_map_state returns NULL invisibly", {
  expect_invisible(fars_map_state(1, 2013))
})
