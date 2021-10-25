covid19lt_git <- function(level, cache) {
    
    # source
    url <- "https://raw.githubusercontent.com/mpiktas/covid19lt/master/data/"
    
    # levels
    if(level == 1){
        
        # download
        file <- paste0(url, "lt-covid19-country.csv")
        x <- read.csv(file, cache = cache)
        
        # format
        x <- map_data(x, c(
            "day"          = "date",
            "confirmed"    = "confirmed",
            "tests"        = "tests",
            "deaths_1"     = "deaths",
            "recovered"    = "recovered",
            "vaccinated_1" = "vaccines_1",
            "vaccinated_2" = "vaccines_2",
            "vaccinated_3" = "vaccines_3",
            "icu"          = "icu",
            "ventilated"   = "vent",
            "hospitalized" = "hosp"
        ))
        
        # total doses
        x$vaccines <- x$vaccines_1 + x$vaccines_2 + x$vaccines_3
        
    }
    if(level >= 2){
        
        # download
        file <- paste0(url, sprintf("lt-covid19-level%s.csv", level))
        x <- read.csv(file, cache = cache)
        
        # format
        x <- map_data(x, c(
            "administrative_level_2" = "admin2",
            "administrative_level_3" = "admin3",
            "day"          = "date",
            "confirmed"    = "confirmed",
            "tests"        = "tests",
            "deaths_1"     = "deaths",
            "recovered"    = "recovered",
            "vaccinated_1" = "vaccines_1",
            "vaccinated_2" = "vaccines_2",
            "vaccinated_3" = "vaccines_3",
            "population"   = "population"
        ))
        
        # total doses
        x$vaccines <- x$vaccines_1 + x$vaccines_2 + x$vaccines_3
        
    }
    
    # date
    x$date <- as.Date(x$date)
    
    # return
    return(x)
}
