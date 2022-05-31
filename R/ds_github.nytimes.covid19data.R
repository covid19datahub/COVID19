#' The New York Times
#'
#' Data source for: United States
#'
#' @param level 1, 2, 3
#' @param fips filter by FIPS code
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#'
#' @source https://github.com/nytimes/covid-19-data
#'
#' @keywords internal
#'
github.nytimes.covid19data <- function(level, fips = NULL){
  if(!level %in% 1:3) return(NULL)
  
  # source
  repo <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/" 
  files <- list(
    '1' = "us.csv", 
    '2' = "us-states.csv", 
    '3' = sprintf("us-counties-%s.csv", 2020:as.integer(format(Sys.Date(), "%Y")))
  )
  
  # build url
  urls  <- paste0(repo, files[[as.character(level)]])
  
  # download
  x <- lapply(urls, read.csv)
  x <- do.call(rbind, x)
  
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
  
  # filter by FIPS code
  if(!is.null(fips))
    x <- x[which(startsWith(as.character(x$fips), fips)),]
  
  return(x) 
}
