test_that("USA-1", {

  x <- test("USA", level = 1, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("USA-2", {

  x <- test("USA", level = 2, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("USA-3", {

  x <- test("USA", level = 3, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("USA-1-raw", {

  x <- test("USA", level = 1, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("USA-2-raw", {

  x <- test("USA", level = 2, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("USA-3-raw", {

  x <- test("USA", level = 3, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})
