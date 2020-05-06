mzcr <- function(level, cache){
  # Author: Martin Benes
  
  # mzcr - Ministery of Health of Czech Republic
  mzcr.covid.api <- "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19"
  mzcr.covid.url <- "https://onemocneni-aktualne.mzcr.cz/covid-19"
  
  if(level == 1) {
    # number of tests
    url   <- sprintf("%s/testy.csv", mzcr.covid.api)
    tests <- read.csv(file = url, cache = cache)
    
    # number of infected
    url       <- sprintf("%s/nakaza.csv", mzcr.covid.api)
    confirmed <- read.csv(url, cache = cache)
    
    # date
    tests$date     <- as.Date(tests[,1])
    confirmed$date <- as.Date(confirmed[,1]) 
    # select columns
    tests     <- reduce(tests, c("date", "testy_celkem" = "tests"))
    confirmed <- reduce(confirmed, c("date", "pocet_celkem" = "confirmed")) 
    
    # formatting
    x <- merge(tests, confirmed, by = "date", all = TRUE)

  }
  if(level == 2) {
    # people confirmed (by regions)
    url <- sprintf("%s/osoby.csv", mzcr.covid.api)
    x   <- read.csv(url, cache = cache)
    
    # regional
    x$date  <- as.Date(x[,1])
    x <- reduce(x, c(
      "date",
      "kraj" = "state"
    ))

    # bindings
    date <- state <- NULL
    
    # cumulative
    x <- x %>%
      dplyr::group_by(date, state) %>%
      dplyr::summarise(confirmed = dplyr::n()) %>%
      dplyr::arrange(date) %>%
      dplyr::group_by(state) %>%
      dplyr::mutate(confirmed = cumsum(confirmed)) 
  }
  
  # return
  return(x)
  
}