covid19peru_git <- function(level, cache) {
    
    # repo
    repo <- "https://raw.githubusercontent.com/jmcastagnetto/covid-19-peru-data"
    url  <- "/main/datos/covid-19-peru-data-augmented.csv"

    # download
    x <- read.csv(paste0(repo,url), cache = cache, na.strings = c("NA",""))

    # format 
    x <- map_data(x, c(
        "date",
        "region",
        "confirmed",
        "deaths",
        "recovered",
        "iso_3166_2_code" = "key",
        "ubigeo"          = "key_numeric",
        "total_tests"     = "tests",
        "pop2019"         = "population",
        "lat"             = "latitude",
        "lon"             = "longitude"
    ))
    
    # convert date
    x$date <- as.Date(x$date)
    
    # level
    if(level==1){
        
        x <- x[is.na(x$key),]

        # hosp        
        url <- "/main/datos/covid-19-peru-detalle-hospitalizados.csv"
        
        # download
        hosp <- read.csv(paste0(repo,url), cache = cache, na.strings = c("NA",""))
    
        # format
        hosp <- map_data(hosp, c(
            "fecha"                = "date",
            "hospitalizados"       = "hosp",
            "ventilacion_mecanica" = "vent"
        ))
        
        # convert date
        hosp$date <- as.Date(hosp$date)
        
        # add icu
        hosp$icu <- hosp$vent
        
        # merge
        x <- merge(x, hosp, by = "date", all = TRUE)
        
    }
    if(level==2){
    
        x <- x[!is.na(x$key),] %>%
            
            dplyr::group_by_at(c("date","key","key_numeric")) %>%
            
            dplyr::summarise(
                confirmed = sum(confirmed),
                deaths    = sum(deaths),
                recovered = sum(recovered),
                tests     = sum(tests)
            )
        
    }
        
    # return
    return(x)
}
