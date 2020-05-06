ministrstvoZaZdravje <- function(cache, level){
  # author: Martin Benes
  
  # source: Ministery of Health, Slovenia
  url <- 'https://www.gov.si/assets/vlada/Koronavirus-podatki/en/EN_Covid-19-all-data.xlsx'
  
  # download
  x <- read_excel(url, cache=cache)$`Covid-19 podatki`
  
  # formatting
  if(level==1){
    
    x <- reduce(x, c(
      'Date'                                         = 'date',
      'Tested (all)'                                 = 'tests',
      'Positive (all)'                               = 'confirmed',
      'All hospitalized on certain day'              = 'hosp',
      'All persons in intensive care on certain day' = 'icu',
      'Discharged'                                   = 'recovered',
      'Deaths (all)'                                 = 'deaths'
    ))
    
    # cumulative
    x$recovered <- cumsum(x$recovered)
    
    # date
    x$date <- as.Date(x$date, format="%Y-%m-%d")
    
  }
  
  return(x)
  
}
