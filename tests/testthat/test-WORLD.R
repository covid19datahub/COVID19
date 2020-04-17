test_that("WORLD-1", {

  x <- test(level = 1, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("WORLD-2", {

  x <- test(level = 2, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("WORLD-3", {

  x <- test(level = 3, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("WORLD-1-raw", {

  x <- test(level = 1, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("WORLD-2-raw", {

  x <- test(level = 2, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("WORLD-3-raw", {

  x <- test(level = 3, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})
