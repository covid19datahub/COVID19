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
    
    # confirmed weekly
    x <- read.csv(csv$weekly$default$cases, na.strings = "NA")
    confirmed_w <- map_data(x, c(
      "datum"     = "date",
      "geoRegion" = "code",
      "sumTotal"  = "confirmed"
    ))
    confirmed_w$date <- as.character(isoweek2date(confirmed_w$date, 7))

    # deaths
    x <- read.csv(csv$daily$death, na.strings = "NA")
    deaths <- map_data(x, c(
        "datum"     = "date",
        "geoRegion" = "code",
        "sumTotal"  = "deaths"
    ))
    
    # deaths weekly
    x <- read.csv(csv$weekly$default$death, na.strings = "NA")
    deaths_w <- map_data(x, c(
      "datum"     = "date",
      "geoRegion" = "code",
      "sumTotal"  = "deaths"
    ))
    deaths_w$date <- as.character(isoweek2date(deaths_w$date, 7))
    
    # tests weekly
    x <- read.csv(csv$weekly$default$test, na.strings = "NA")
    tests_w <- map_data(x, c(
      "datum"     = "date",
      "geoRegion" = "code",
      "sumTotal"  = "tests"
    ))
    tests_w$date <- as.character(isoweek2date(tests_w$date, 7))
    
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
    x <- vaccines %>%
        full_join(vaccinated, by = by) %>%
        full_join(hosp, by = by) %>%
        full_join(tests_w, by = by) %>%
        full_join(bind_rows(
          confirmed, 
          confirmed_w[confirmed_w$date > max(confirmed$date),]
        ), by = by) %>%
        full_join(bind_rows(
          deaths, 
          deaths_w[deaths_w$date > max(deaths$date),]
        ), by = by)

    # clean code
    x <- x[!is.na(x$code),]
    
    # filter by state
    if(level==1){
        x <- x[x$code==state,]
    }
    # select only Swiss cantons
    else{
        x <- x[x$code %in% c(
          "AG", "AI", "AR", "BE", "BL", "BS", "FR", "GE",
          "GL", "GR", "JU", "LU", "NE", "NW", "OW", "SG",
          "SH", "SO", "SZ", "TG", "TI", "UR", "VD", "VS",
          "ZG", "ZH"
        ),]
    }
    
    # convert date
    x$date <- as.Date(x$date)
    
    return(x)
}
