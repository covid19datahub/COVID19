ministrstvoZaZdravje <- function(cache, level){
  # author: Martin Benes
  
  # source: Ministery of Health, Slovenia
  url <- 'https://www.gov.si/assets/vlada/Koronavirus-podatki/en/EN_Covid-19-all-data.xlsx'
  
  # download
  x <- read_excel(url, cache=cache)$`Covid-19 podatki`
  
  # format
  if(level==1){
    
    colnames(x) <- mapvalues(colnames(x), c(
      'Date'                                         = 'date',
      'Tested (all)'                                 = 'tests',
      'Positive (all)'                               = 'confirmed',
      'All hospitalized on certain day'              = 'hospitalized',
      'All persons in intensive care on certain day' = 'icu',
      'Discharged'                                   = 'recovered',
      'Deaths (all)'                                 = 'deaths'
    ))
    
    #x$date         <- as.Date(x$date, format="%Y.%m.%d.")
    x$recovered <- cumsum(x$recovered)
    
  }
  
  x$country <- 'SVN'
  
  return(x)
  
}
