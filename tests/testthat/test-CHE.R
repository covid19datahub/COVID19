test_that("CHE-1", {

  x <- test("CHE", level = 1, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("CHE-2", {

  x <- test("CHE", level = 2, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("CHE-1-raw", {

  x <- test("CHE", level = 1, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("CHE-2-raw", {

  x <- test("CHE", level = 2, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})
