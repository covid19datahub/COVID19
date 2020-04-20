mzcr <- function(cache){
  # Author: Martin Benes
  
  # mzcr - Ministery of Health of Czech Republic
  mzcr.covid.api <- "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19"
  mzcr.covid.url <- "https://onemocneni-aktualne.mzcr.cz/covid-19"
  
  # number of tests
  url   <- sprintf("%s/testy.csv", mzcr.covid.api)
  tests <- read.csv(file = url, cache = cache)
  
  # number of infected
  url       <- sprintf("%s/nakaza.csv", mzcr.covid.api)
  confirmed <- read.csv(url, cache = cache)
  
  # formatting
  x <- merge(tests, confirmed)
  x$date      <- as.Date(x[,1])
  x$tests     <- x$testy_celkem
  x$confirmed <- x$pocet_celkem
  
  # return
  return(x)
  
}
