yahoo <- function(cache, symbol){
  
  # url
  period <- sprintf("?period1=%s&period2=%s", as.integer(as.POSIXct(as.Date("2019-01-01"))), as.integer(as.POSIXct(Sys.Date())))
  url    <- paste0("https://query1.finance.yahoo.com/v7/finance/download/",symbol, period,"&interval=1d&events=history")
  
  # download
  x <- read.csv(url, cache = cache)
  
  return(x)
  
}
