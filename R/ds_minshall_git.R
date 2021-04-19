minshall_git <- function(iso, level){
  
  # source: https://gitlab.com/minshall/covid-19
  url <- 'https://somenumbers.info/covid-19/csvs/coleaned.csv.gz'
  
  # download
  x <- suppressWarnings(readr::read_csv(url, progress = FALSE))
  x <- x[x$Iso3c==iso,]
  
  # admin
  s <- strsplit(x$Combined_Key, split = ",\\s*")
  x$admin1 <- sapply(s, function(x) x[3])
  x$admin2 <- sapply(s, function(x) x[2])
  x$admin3 <- sapply(s, function(x) x[1])
  
  # level
  if(level==1)
    x <- x[x$admin1!="" & x$admin2=="" & x$admin3=="",]
  if(level==2)
    x <- x[x$admin1!="" & x$admin2!="" & x$admin3=="",]
  if(level==3)
    x <- x[x$admin1!="" & x$admin2!="" & x$admin3!="",]
  
  # format
  x <- map_data(x, c(
    "admin1",
    "admin2",
    "admin3",
    "Date"      = "date",
    "Confirmed" = "confirmed",
    "Deaths"    = "deaths",
    "Recovered" = "recovered",
    "Lat"       = "latitude",
    "Long_"     = "longitude"
  ))
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
  
}
