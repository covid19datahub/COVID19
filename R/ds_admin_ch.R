admin_ch <- function(level, id = NULL) {
    
    # metadata
    meta <- jsonlite::fromJSON("https://www.covid19.admin.ch/api/data/context")
    csv <- meta$sources$individual$csv
    
    # vaccines
    x <- read.csv(csv$vaccDosesAdministered, na.strings = c("NA"))
    vaccines <- map_data(x, c(
        "date"      = "date",
        "geoRegion" = "code",
        "sumTotal"  = "vaccines"
    ))
    
    # confirmed
    x <- read.csv(csv$daily$cases, na.strings = c("NA"))
    confirmed <- map_data(x, c(
        "datum"     = "date",
        "geoRegion" = "code",
        "sumTotal"  = "confirmed"
    ))
    
    # deaths
    x <- read.csv(csv$daily$death, na.strings = c("NA"))
    deaths <- map_data(x, c(
        "datum"     = "date",
        "geoRegion" = "code",
        "sumTotal"  = "deaths"
    ))

    # tests
    x <- read.csv(csv$daily$test, na.strings = c("NA"))
    tests <- map_data(x, c(
        "datum"     = "date",
        "geoRegion" = "code",
        "sumTotal"  = "tests"
    ))
    
    # hosp
    x <- read.csv(csv$daily$hospCapacity, na.strings = c("NA"))
    x <- x[x$type_variant=="nfp",]
    hosp <- map_data(x, c(
        "date"      = "date",
        "geoRegion" = "code",
        "Total_Covid19Patients"  = "hosp",
        "ICU_Covid19Patients"    = "icu"
    ))
        
    # merge 
    x <- merge(vaccines, confirmed, all = TRUE)
    x <- merge(x, deaths, all = TRUE)
    x <- merge(x, tests, all = TRUE)
    x <- merge(x, hosp, all = TRUE)
    
    # clean id
    x <- x[!is.na(x$code),]
    
    # date
    x$date <- as.Date(x$date)

    # filter by level
    if(level==1){
        x <- x[x$code==id,]
        x$code <- NULL
    }
    else{
        x <- x[!(x$code %in% c("CH", "FL", "CHFL")),]
    }
        
    # return
    return(x)
    
}
