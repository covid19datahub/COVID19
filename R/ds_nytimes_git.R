#' The New York Times 
#' 
#' Imports confirmed cases and deaths for United States at national, state, and county level 
#' from The New York Times.
#' 
#' @source 
#' https://github.com/nytimes/covid-19-data
#' 
#' @keywords internal
#' 
nytimes_git <- function(level, cache = FALSE, fips = NULL){
  if(level>3) return(NULL)
  
  # source
  repo <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/" 
  urls <- c("us.csv","us-states.csv","us-counties.csv")
  url  <- paste0(repo, urls[level])
  
  # download
  x   <- read.csv(url)
  
  # format 
  x <- map_data(x, c(
    'date',
    'state',
    'fips',
    'county' = 'city',
    'cases'  = 'confirmed',
    'deaths' = 'deaths'
  ))

  # clean
  if(level==3){
    
    x <- x[x$city!="Unknown",]
    x$fips[x$city=="New York City"] <- 36061
    x$fips[x$city=="Kansas City"]   <- 29901
    x$fips[x$city=="Joplin"]        <- 29592
    
  }
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")
  
  # filter
  if(!is.null(fips))
    x <- x[which(startsWith(as.character(x$fips), fips)),]
  
  # return
  return(x) 
  
}


