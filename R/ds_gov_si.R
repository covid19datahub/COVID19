gov_si <- function(cache, level){
  # author: Martin Benes
  
  # source: Ministery of Health, Slovenia
  url <- 'https://www.gov.si/assets/vlada/Koronavirus-podatki/en/EN_Covid-19-all-data.xlsx'
  
  # download
  x <- read.excel(url, cache=cache)$`Covid-19 podatki`
  
  # formatting
  if(level==1){
    
    # x <- map_data(x, c(
    #   'Dátum'                                = 'date',
    #   'Mintavételek száma (összesen)'        = 'tests',
    #   'pozitív esetek száma (összesen)'      = 'confirmed',
    #   'hospitalizált'                        = 'hosp',
    #   'intenzív ellátásra szoruló'           = 'icu',
    #   'elhunytak száma összesen'             = 'deaths'
    # ))
    x <- map_data(x, c(
      'Date'                                         = 'date',
      'Tested (all)'                                 = 'tests',
      'Positive (all)'                               = 'confirmed',
      'All hospitalized on certain day'              = 'hosp',
      'All persons in intensive care on certain day' = 'icu',
      'Deaths (all)'                                 = 'deaths'
    ))
    
    # clean deaths
    x$deaths <- as.numeric(gsub("\\*$", "", x$deaths))
    
    # format date
    d <- as.Date(x$date, format="%Y-%m-%d")
    if(all(is.na(d)))
      d <- as.Date(suppressWarnings(as.numeric(x$date)), origin = "1899-12-30")   
    
    # date and clean
    x$date <- d
    x <- x[!is.na(d),]
    
  }
  
  return(x)
  
}
