#' Commissario straordinario per l'emergenza Covid-19, Presidenza del Consiglio dei Ministri
#'
#' Data source for: Italy
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 2:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://github.com/italia/covid19-opendata-vaccini
#'
#' @keywords internal
#'
github.italia.covid19opendatavaccini <- function(level){
  if(!level %in% 1:2) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/somministrazioni-vaccini-latest.csv"
  x <- read.csv(url)
  
  # format
  x <- map_data(x, c(
    "data" = "date",
    "forn" = "type",
    "N2" = "state",
    "d1" = "first",
    "d2" = "second",
    "dpi" = "oneshot",
    "db1" = "extra_1",
    "dbi" = "extra_2",
    "db2" = "extra_3"
  ))
  
  # people vaccinated and total doses
  x <- x %>%
    dplyr::mutate(
      vaccines = first + second + oneshot + extra_1 + extra_2 + extra_3,
      people_vaccinated = first + oneshot,
      people_fully_vaccinated = second + oneshot + first*(type=="Janssen"))
  
  if(level==1){
    
    # vaccines
    x <- x %>%
      # for each date
      dplyr::group_by(date) %>%
      # compute total counts
      dplyr::summarise(
        vaccines = sum(vaccines),
        people_vaccinated = sum(people_vaccinated),
        people_fully_vaccinated = sum(people_fully_vaccinated)) %>%
      # sort by date
      dplyr::arrange(date) %>%
      # cumulate
      dplyr::mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))  
  
  }
  
  if(level==2){
    
    # vaccines
    x <- x %>%
      # for each date and region
      dplyr::group_by(date, state) %>%
      # compute total counts
      dplyr::summarise(
        vaccines = sum(vaccines),
        people_vaccinated = sum(people_vaccinated),
        people_fully_vaccinated = sum(people_fully_vaccinated)) %>%
      # group by date
      dplyr::group_by(state) %>%
      # sort by date
      dplyr::arrange(date) %>%
      # cumulate
      dplyr::mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))  
    
  }

  # format date
  x$date <- as.Date(x$date)

  return(x)
}
