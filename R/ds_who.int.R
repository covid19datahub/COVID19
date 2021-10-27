#' World Health Organization
#'
#' Data source for: Worldwide
#'
#' @param level 1
#' @param id filter by 2-letter ISO code of country 
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#'
#' @source https://covid19.who.int
#'
#' @keywords internal
#'
who.int <- function(level = 1, id = NULL){
  if(level!=1) return(NULL)
  
  # download
  url <- "https://covid19.who.int/WHO-COVID-19-global-data.csv"
  x <- read.csv(url, fileEncoding = "UTF-8-BOM")
  
  # formatting
  x <- map_data(x, c(
    'Date_reported'     = 'date',
    'Country_code'      = 'id',
    'Country'           = 'country',
    'Cumulative_cases'  = 'confirmed',
    'Cumulative_deaths' = 'deaths'
  ))
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")

  # filter
  if(!is.null(id))
    x <- x[which(x$id==id),]
  
  return(x)
}
