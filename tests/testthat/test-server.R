test_that("server", {

  url <- "https://storage.covid19datahub.io/rawdata-1.csv"
  x   <- read.csv(url)
  
  expect_equal(max(x$date) == Sys.Date(), TRUE)
  
})

