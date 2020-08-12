test_that("server", {

  url <- "https://storage.covid19datahub.io/data-1.csv"
  x   <- read.csv(url)
  
  expect_equal(max(x$date) >= (Sys.Date()-1), TRUE)
  
})

