#' Sledilnik
#'
#' Data source for: Slovenia
#'
#' @param level 1
#'
#' @section Level 1:
#' - tests
#'
#' @source https://github.com/sledilnik/data
#'
#' @keywords internal
#'
github.sledilnik.data <- function(level){
  if(level != 1) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/sledilnik/data/master/csv/cases-opsi-light.csv"
  x <- read.csv(url)
  
  # format
  x <- map_data(x, c(
    'TheDate' = 'date',
    'st_test_PCR' = 'pcr_tests',
    'st_test_HAGT' = 'antigen_tests')
  )
  
  # compute tests
  x <- x %>%
    mutate(test_sum = pcr_tests + antigen_tests) %>%
    arrange(date) %>%
    mutate(tests = cumsum(test_sum))
  
  # convert to date
  x$date <- as.Date(x$date)
  
  return(x)
}