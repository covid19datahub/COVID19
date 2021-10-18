#' Matt Bolton 
#' 
#' Imports confirmed cases, deaths, recovered, tests, hospitalizations, and vaccines 
#' from Matt Bolton's Github repository for Australia. Data aggregated from www.covid19data.com.au, 
#' which is sourced from Australian governments at federal, state and territory levels. 
#' See www.covid19data.com.au/data-notes for details and notes.
#' 
#' @source 
#' https://github.com/M3IT/COVID-19_Data
#' 
#' @keywords internal
#' 
covid19au_git <- function(level) {
   
    # download
    repo <- "https://raw.githubusercontent.com/M3IT/COVID-19_Data"
    url  <- "/master/Data/COVID19_Data_Hub.csv"
    x    <- read.csv(paste0(repo,url), na.strings = c("NA",""))
    
    # format date
    x$date <- as.Date(x$date)

    # filter by level
    x <- x[x$administrative_area_level == level,]

    # return
    return(x)
    
}
