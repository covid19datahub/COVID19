test_that("server-1", {

  url <- "https://storage.covid19datahub.io/rawdata-1.csv"
  x   <- read.csv(url)
  
  expect_equal(max(x$date) == Sys.Date(), TRUE)
  
})

test_that("server-2", {
  
  url <- "https://storage.covid19datahub.io/rawdata-2.csv"
  x   <- read.csv(url)
  
  expect_equal(max(x$date) == Sys.Date(), TRUE)
  
})

test_that("server-3", {
  
  url <- "https://storage.covid19datahub.io/rawdata-3.csv"
  x   <- read.csv(url)
  
  expect_equal(max(x$date) == Sys.Date(), TRUE)
  
})
