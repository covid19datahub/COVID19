test_that("ITA-1", {

  x <- test("ITA", level = 1, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("ITA-2", {

  x <- test("ITA", level = 2, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("ITA-3", {

  x <- test("ITA", level = 3, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("ITA-1-raw", {

  x <- test("ITA", level = 1, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("ITA-2-raw", {

  x <- test("ITA", level = 2, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("ITA-3-raw", {

  x <- test("ITA", level = 3, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})
