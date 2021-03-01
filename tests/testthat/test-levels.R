test_that("level-1", {

  # try 
  covid19(level = 1, raw = TRUE, vintage = FALSE, verbose = FALSE, debug = TRUE)

  # success
  return(TRUE)
  
})

test_that("level-2", {
  
  # try 
  covid19(level = 2, raw = TRUE, vintage = FALSE, verbose = FALSE, debug = TRUE)
  
  # success
  return(TRUE)
  
})

test_that("level-3-ITA", {
  
  # try 
  covid19("ITA", level = 3, raw = TRUE, vintage = FALSE, verbose = FALSE, debug = TRUE)
  
  # success
  return(TRUE)
  
})

test_that("level-3-USA", {
  
  # try 
  covid19("USA", level = 3, raw = TRUE, vintage = FALSE, verbose = FALSE, debug = TRUE)
  
  # success
  return(TRUE)
  
})