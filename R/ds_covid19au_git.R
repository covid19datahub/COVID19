covid19au_git <- function(level, cache) {
    # Author: Matt Bolton (github.com/M3IT)
    # Date:   2020-06-13
    
    # Data aggregated from www.covid19data.com.au, which is sourced from Australian governments at federal, state and territory levels. 
    # See www.covid19data.com.au/data-notes for details and notes.

    # Read data
    repo <- "https://raw.githubusercontent.com/M3IT/COVID-19_Data"
    url  <- "/master/Data/COVID19_Data_Hub.csv"

    x    <- read.csv(paste0(repo,url), cache = cache)
    
    # Minimal additional code as data already formatted as required
    x$date <- as.Date(x$date)

    # Filter for level
    # Note: levels 1 & 2 available only
    x <- x[x$administrative_area_level == level,]

    # return
    return(x)
}
