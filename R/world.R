world <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- jhuCSSE(file = "global", cache = cache, level = level)

  map <- c(
    'Burma'               = 'Myanmar',
    'Cabo Verde'          = 'Cape Verde',
    'Congo (Brazzaville)' = 'Congo',
    'Congo (Kinshasa)'    = 'Congo, the Democratic Republic of the',
    'Czechia'             = 'Czech Republic',
    'Eswatini'            = 'Swaziland',
    'North Macedonia'     = 'Macedonia',
    'Taiwan*'             = 'Taiwan',
    'US'                  = 'United States',
    'West Bank and Gaza'  = 'Palestine'
  )

  x$country <- as.character(x$country)
  x$country <- mapvalues(x$country, map)

  # mobility data
  # a <- apple(cache = cache)
  # x <- merge(x, a, by.x = c('date','country'), by.y = c('date','region'), all.x = TRUE)

  # ISO code
  iso <- db("ISO")
  iso <- iso[,c('country','iso_alpha_3','mkt_index')]
  x   <- merge(x, iso, by = 'country')

  # level
  if(level==1){
    
    # tests
    o <- owid(cache = cache)  
    x <- merge(x, o, by = c('date','iso_alpha_3'), all.x = TRUE)
    
    # mkt index
    y <- yahoo(cache = cache, symb = x$mkt_index)
    x <- merge(x, y, all.x = TRUE)
    
  }
  if(level==2){
    
    x$id <- id(x$state)    
    
  }

  # return
  return(x)

}
