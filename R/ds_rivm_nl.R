rivm_nl <- function(level, cache) {
  
  # download
  url <- "https://data.rivm.nl/covid-19/COVID-19_aantallen_gemeente_per_dag.csv"
  x   <- read.csv(url, cache = cache, sep = ";")
  
  # parse
  x <- map_data(x, c(
    "Date_of_publication" = "date",
    "Municipality_code"   = "municipality_code",
    "Municipality_name"   = "municipality",
    "Province"            = "province",
    "Total_reported"      = "confirmed",
    "Hospital_admission"  = "hosp", 
    "Deceased"            = "deaths")) 
  
  # sanitize
  x$date <- as.Date(x$date)
  x$province <- trimws(x$province)
  x$municipality <- trimws(x$municipality)

  # level
  if(level == 1){
    by <- c("date") 
  }
  if(level == 2){
    by <- c("date", "province")
    x <- x[!is.na(x$province),]
  }
  if(level == 3){
    by <- c("date", "province", "municipality")
    x <- x[!is.na(x$province) & !is.na(x$municipality),]
  }
  
  # group and cumulate
  x <- x %>% 
    dplyr::group_by_at(by) %>%
    dplyr::summarise(confirmed = sum(confirmed),
                     deaths    = sum(deaths),
                     hosp      = sum(hosp)) %>%
    dplyr::group_by_at(by[-1]) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(confirmed = cumsum(confirmed),
                  deaths    = cumsum(deaths))
  
  # return
  return(x)
  
}
