#' Federal Office of Public Health
#'
#' Data source for: Switzerland and Liechtenstein
#'
#' @param level 1, or 2 (only for Switzerland)
#' @param state one of CH (Switzerland) or FL (Liechtenstein)
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @source https://www.covid19.admin.ch/en/overview
#'
#' @keywords internal
#'
admin.ch <- function(level, state = NULL) {
    if(state=="FL" & level!=1) return(NULL)
    if(state=="CH" & !level %in% 1:2) return(NULL)
    
    # metadata
    meta <- jsonlite::fromJSON("https://www.covid19.admin.ch/api/data/context")
    csv <- meta$sources$individual$csv
    
    # total vaccine doses 
    x <- read.csv(csv$vaccDosesAdministered, na.strings = "NA")
    vaccines <- map_data(x, c(
        "date"      = "date",
        "geoRegion" = "code",
        "sumTotal"  = "vaccines"
    ))
    
    # people vaccinated
    x <- read.csv(csv$vaccPersonsV2, na.strings = "NA")
    vaccinated <- map_data(x, c(
        "date"      = "date",
        "geoRegion" = "code",
        "sumTotal"  = "total",
        "type"      = "type",
        "age_group" = "age"
    )) 
    # filter by total population and pivot
    vaccinated <- vaccinated %>%
        filter(age=="total_population") %>%
        pivot_wider(id_cols = c("code", "date"), names_from = "type", values_from = "total") %>%
        rename(people_vaccinated = COVID19AtLeastOneDosePersons, 
               people_fully_vaccinated = COVID19FullyVaccPersons)
    
    # confirmed
    x <- read.csv(csv$daily$cases, na.strings = "NA")
    confirmed <- map_data(x, c(
        "datum"     = "date",
        "geoRegion" = "code",
        "sumTotal"  = "confirmed"
    ))
    
    # deaths
    x <- read.csv(csv$daily$death, na.strings = "NA")
    deaths <- map_data(x, c(
        "datum"     = "date",
        "geoRegion" = "code",
        "sumTotal"  = "deaths"
    ))
    
    # tests
    x <- read.csv(csv$daily$test, na.strings = "NA")
    tests <- map_data(x, c(
        "datum"     = "date",
        "geoRegion" = "code",
        "sumTotal"  = "tests"
    ))
    
    # hosp
    x <- read.csv(csv$daily$hospCapacity, na.strings = "NA")
    x <- x[x$type_variant=="nfp",]
    hosp <- map_data(x, c(
        "date"      = "date",
        "geoRegion" = "code",
        "Total_Covid19Patients"  = "hosp",
        "ICU_Covid19Patients"    = "icu"
    ))
    
    # merge 
    by <- c("code", "date")
    x <- confirmed %>%
        full_join(vaccines, by = by) %>%
        full_join(vaccinated, by = by) %>%
        full_join(deaths, by = by) %>%
        full_join(tests, by = by) %>%
        full_join(hosp, by = by)

    # clean code
    x <- x[!is.na(x$code),]
    
    # filter by state
    if(level==1){
        x <- x[x$code==state,]
    }
    # select only Swiss cantons
    else{
        x <- x[!(x$code %in% c("CH", "FL", "CHFL", "all", "neighboring_chfl", "unknown")),]
    }
    
    # convert date
    x$date <- as.Date(x$date)
    
    return(x)
}
