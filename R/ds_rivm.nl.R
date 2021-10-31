#' National Institute for Public Health and the Environment
#'
#' Data source for: Netherlands
#'
#' @param level 1, 2, 3
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
#' @source https://data.rivm.nl/covid-19/
#'
#' @keywords internal
#'
rivm.nl <- function(level) {
  if(!level %in% 1:3) return(NULL)

  # download
  url <- "https://data.rivm.nl/covid-19/COVID-19_aantallen_gemeente_per_dag.csv"
  x   <- read.csv(url, sep = ";")
  
  # format
  x <- map_data(x, c(
    "Date_of_publication" = "date",
    "Municipality_code"   = "municipality_code",
    "Municipality_name"   = "municipality",
    "Province"            = "province",
    "Total_reported"      = "confirmed",
    "Deceased"            = "deaths")) 
  
  # sanitize
  x$date <- as.Date(x$date)
  x$province <- trimws(x$province)
  x$municipality <- trimws(x$municipality)
  
  # group by
  if(level == 1){
    by <- c("date") 
  }
  if(level == 2){
    by <- c("date", "province")
    x <- x[!is.na(x$province),]
  }
  if(level == 3){
    by <- c("date", "province", "municipality")
    x <- x[!is.na(x$province) & !is.na(x$municipality),]
  }
  
  # aggregate
  x <- x %>% 
    # for each date and area
    dplyr::group_by_at(by) %>%
    # compute total counts
    dplyr::summarise(
      confirmed = sum(confirmed),
      deaths    = sum(deaths)) %>%
    # group by area
    dplyr::group_by_at(by[-1]) %>%
    # sort by date
    dplyr::arrange(date) %>%
    # cumulate
    dplyr::mutate(
      confirmed = cumsum(confirmed),
      deaths    = cumsum(deaths))
  
  return(x)
}
