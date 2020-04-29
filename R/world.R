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
  iso    <- db("ISO")
  isomap <- iso$iso_alpha_3
  names(isomap) <- iso$country
  x$iso_alpha_3 <- mapvalues(x$country, isomap)

  # level
  if(level==1){
    
    o <- owid(cache = cache)  
    x <- drop(merge(x, o, by = c('date','iso_alpha_3'), all = TRUE, suffixes = c('','.drop')))
    
  }
  if(level==2){
    
    x$id <- id(x$state)    
    
  }

  # return
  return(x)

}
