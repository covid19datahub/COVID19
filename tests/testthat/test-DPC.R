test_that("DPC-1", {

  x <- test("DPC", level = 1, end = Sys.Date()-3, raw = FALSE)
  expect_equal(x, 1, tolerance = 0.01)

})

test_that("DPC-1-raw", {

  x <- test("DPC", level = 1, end = Sys.Date()-3, raw = TRUE)
  expect_equal(x, 1, tolerance = 0.01)

})
