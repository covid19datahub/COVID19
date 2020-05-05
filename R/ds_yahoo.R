yahoo <- function(cache, symb){
  
  # symbols
  symb <- unique(symb)
  symb <- symb[!is.na(symb)]
  
  # download
  x <- sapply(symb, simplify = FALSE, function(symb){
    
    # url
    period <- sprintf("period1=%s&period2=%s", as.integer(as.POSIXct(as.Date("2019-01-01"))), as.integer(as.POSIXct(Sys.Date())))
    url    <- paste0("https://query1.finance.yahoo.com/v7/finance/download/",symb,"?",period,"&interval=1d&events=history")
    
    # download
    x <- try(read.csv(url, cache = cache))
    if("try-error" %in% class(x))
      return(NULL)
    
    # formatting
    x$Date   <- as.Date(x$Date)
    for(i in 2:ncol(x))
      x[[i]] <- suppressWarnings(as.numeric(x[[i]]))
    
    # return
    return(x)
    
  }) %>%
    
  dplyr::bind_rows(.id = "mkt_index")
  
  # reduce
  x <- reduce(x, c(
    "mkt_index",
    'Date'   = 'date', 
    'Close'  = 'mkt_close', 
    'Volume' = 'mkt_volume'))
  
  # return
  return(x)
  
}
