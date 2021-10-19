#' Commissario straordinario per l'emergenza Covid-19, Presidenza del Consiglio dei Ministri 
#' 
#' Imports Italian vaccination data at national and regional level from Commissario 
#' straordinario per l'emergenza Covid-19.
#' 
#' Italy provides vaccination data as follows:
#' - number of first and second doses for a 2 doses vaccination cycle 
#' - number of oneshot doses for a 1 dose vaccination cycle
#' - number of extra doses 
#' 
#' We compute vaccines_1 as first+oneshot and vaccines_2 as second+oneshot..
#' 
#' @source 
#' github.com/italia/covid19-opendata-vaccini
#' 
#' @keywords internal
#' 
covid19vaccini_git <- function(level){
  if(level>2) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/somministrazioni-vaccini-latest.csv"
  x <- read.csv(url)
  
  # format
  x <- map_data(x, c(
    "data_somministrazione" = "date",
    "codice_NUTS2" = "state",
    "prima_dose" = "first",
    "seconda_dose" = "second",
    "pregressa_infezione" = "oneshot",
    "dose_aggiuntiva" = "extra"
  ))
  
  # vaccines
  x <- x %>%
    dplyr::mutate(
      vaccines = first + second + oneshot + extra,
      vaccines_1 = first + oneshot,
      vaccines_2 = second + oneshot)
  
  if(level==1){
    
    # group by date and cumulate
    x <- x %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(
        vaccines = sum(vaccines),
        vaccines_1 = sum(vaccines_1),
        vaccines_2 = sum(vaccines_2)) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(
        vaccines = cumsum(vaccines),
        vaccines_1 = cumsum(vaccines_1),
        vaccines_2 = cumsum(vaccines_2))  
  
  }
  
  if(level==2){
    
    # group by date and state, then cumulate
    x <- x %>%
      dplyr::group_by(date, state) %>%
      dplyr::summarise(
        vaccines = sum(vaccines),
        vaccines_1 = sum(vaccines_1),
        vaccines_2 = sum(vaccines_2)) %>%
      dplyr::group_by(state) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(
        vaccines = cumsum(vaccines),
        vaccines_1 = cumsum(vaccines_1),
        vaccines_2 = cumsum(vaccines_2))  
    
  }

  # format date
  x$date <- as.Date(x$date)

  # return
  return(x)
    
}
