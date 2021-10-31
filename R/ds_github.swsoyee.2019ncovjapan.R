#' Su Wei
#'
#' Data source for: Japan and Cruise Ships
#'
#' @param level 1, 2
#' @param id filter by name
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#' 
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @source https://github.com/swsoyee/2019-ncov-japan/blob/master/README.en.md
#'
#' @keywords internal
#'
github.swsoyee.2019ncovjapan <- function(level, id = NULL) {
  if(!level %in% 1:2) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/swsoyee/2019-ncov-japan/master/50_Data/covid19_jp.csv"
  x <- read.csv(url)
  
  # fix severe
  if("severe" %in% colnames(x))
    x$icu <- x$severe
  
  # fix value for Costa Atlantica
  idx <- which(x$date=="2020-05-10" & x$administrative_area_level_2=="Costa Atlantica")
  x$tests[idx] <- 623
  
  # convert to date
  x$date <- as.Date(x$date)
  
  # filter by level
  x <- x[x$administrative_area_level == level,]
  
  # filter by id
  if(!is.null(id))
    x <- x[which(x$administrative_area_level_2 == id),]
  # remove cruise ships and other non-geographical entities
  else if(level==1)
    x <- x[is.na(x$administrative_area_level_2),]
    
  return(x)
}
