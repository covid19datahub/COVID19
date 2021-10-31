#' Vaidotas Zemlys-Balevicius
#'
#' Data source for: Lithuania
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#' 
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://github.com/mpiktas/covid19lt
#'
#' @keywords internal
#'
github.mpiktas.covid19lt <- function(level) {
    if(!level %in% 1:3) return(NULL)
    
    # source
    url <- "https://raw.githubusercontent.com/mpiktas/covid19lt/master/data/"
    
    # levels
    if(level == 1){
        
        # download
        file <- paste0(url, "lt-covid19-country.csv")
        x <- read.csv(file)
        
        # format
        x <- map_data(x, c(
            "day"          = "date",
            "confirmed"    = "confirmed",
            "tests"        = "tests",
            "deaths_1"     = "deaths",
            "recovered"    = "recovered",
            "icu"          = "icu",
            "ventilated"   = "vent",
            "hospitalized" = "hosp",
            "vaccinated_1" = "dose_1",
            "vaccinated_2" = "dose_2",
            "vaccinated_3" = "dose_3",
            "fully_protected" = "people_fully_vaccinated"
        ))
        
        # people vaccinated
        x$people_vaccinated <- x$dose_1
        
        # total vaccine doses
        x$vaccines <- x$dose_1 + x$dose_2 + x$dose_3
        
    }
    
    if(level==2 | level==3){
        
        # download
        file <- paste0(url, sprintf("lt-covid19-level%s.csv", level))
        x <- read.csv(file)
        
        # format
        x <- map_data(x, c(
            "administrative_level_2" = "admin2",
            "administrative_level_3" = "admin3",
            "population"             = "population",
            "day"                    = "date",
            "confirmed"              = "confirmed",
            "tests"                  = "tests",
            "deaths_1"               = "deaths",
            "recovered"              = "recovered",
            "vaccinated_1"           = "dose_1",
            "vaccinated_2"           = "dose_2",
            "vaccinated_3"           = "dose_3",
            "fully_protected"        = "people_fully_vaccinated"
        ))
        
        # people vaccinated
        x$people_vaccinated <- x$dose_1
        
        # total vaccine doses
        x$vaccines <- x$dose_1 + x$dose_2 + x$dose_3
        
    }
    
    # date
    x$date <- as.Date(x$date)
    
    # return
    return(x)
}
