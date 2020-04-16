WORLD <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- jhuCSSE(file = "global", cache = cache)

  # filter
  if(level==2)
    x <- x[x$lat!=0 & x$lng!=0 & x$state!="",]

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

  idx <- which(x$state=="Grand Princess")
  x$country[idx] <- "Grand Princess"
  x$state[idx]   <- ""

  # mobility data
  a <- apple(cache = cache)
  x <- merge(x, a, by.x = c('date','country'), by.y = c('date','region'), all.x = TRUE)

  # ISO code
  iso    <- db("ISO")
  isomap <- iso$iso_alpha_3
  names(isomap) <- iso$country
  x$iso_alpha_3 <- mapvalues(x$country, isomap)

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db/
  x$id <- id(x$state)

  # return
  return(x)

}
