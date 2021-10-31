#' Jesus M. Castagnetto
#'
#' Data source for: Peru
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#'
#' @source https://github.com/jmcastagnetto/covid-19-peru-data
#'
#' @keywords internal
#'
github.jmcastagnetto.covid19perudata <- function(level) {
    if(!level %in% 1:2) return(NULL)
    
    # download cases
    repo <- "https://raw.githubusercontent.com/jmcastagnetto/covid-19-peru-data"
    url  <- "/main/datos/covid-19-peru-data-augmented.csv"
    x.cases <- read.csv(paste0(repo,url), na.strings = c("NA",""))
    
    # format cases
    x.cases <- map_data(x.cases, c(
        "date"            = "date",
        "region"          = "region",
        "iso_3166_2_code" = "id",
        "ubigeo"          = "ubigeo",
        "confirmed"       = "confirmed",
        "deaths"          = "deaths",
        "recovered"       = "recovered",
        "total_tests"     = "tests"
    ))
    
    # convert date
    x.cases$date <- as.Date(x.cases$date)
    
    if(level==1){
        
        # download hosp        
        url <- "/main/datos/covid-19-peru-detalle-hospitalizados.csv"
        x.hosp <- read.csv(paste0(repo,url), na.strings = c("NA",""))
        
        # format hosp
        x.hosp <- map_data(x.hosp, c(
            "fecha"                = "date",
            "hospitalizados"       = "hosp",
            "ventilacion_mecanica" = "vent"
        ))
        
        # convert date
        x.hosp$date <- as.Date(x.hosp$date)
        
        # download icu
        url <- "/main/datos/covid-19-peru-camas-uci.csv"
        x.icu <- read.csv(paste0(repo,url), na.strings = c("NA",""))
        
        # format icu
        x.icu <- map_data(x.icu, c(
            "fecha"  = "date",
            "estado" = "status",
            "total"  = "icu"
        ))
        
        # select icu beds in use
        x.icu <- filter(x.icu, status=="en uso")
        
        # convert date
        x.icu$date <- as.Date(x.icu$date)
        
        # select national level cases
        x.cases <- x.cases[is.na(x.cases$id),]
        
        # merge
        x <- x.cases %>%
            full_join(x.hosp, by = "date") %>%
            full_join(x.icu, by = "date")
        
    }
    
    if(level==2){
        
        # cases
        x <- x.cases %>%
            # drop national level cases
            filter(!is.na(id)) %>%
            # group by date and region
            dplyr::group_by(date, id) %>%
            # compute total counts
            dplyr::summarise(
                confirmed = sum(confirmed),
                deaths    = sum(deaths),
                recovered = sum(recovered),
                tests     = sum(tests))
        
    }
    
    return(x)
}
