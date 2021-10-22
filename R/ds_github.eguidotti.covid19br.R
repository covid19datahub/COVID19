github.eguidotti.covid19br <- function(level){
  if(level!=3) return(NULL)
  
  url <- "https://raw.githubusercontent.com/eguidotti/covid19br/main/data.csv.gz"
  x <- data.table::fread(url, encoding = "UTF-8", showProgress = FALSE)
  
  x <- map_data(x, c(
    "Date" = "date",
    "IBGE" = "ibge",
    "TotalVaccinations" = "vaccines",
    "PeopleVaccinated" = "people_vaccinated",
    "PeopleFullyVaccinated" = "people_fully_vaccinated"
  ))
  
  x <- x[which(x$ibge!="999999"),]
  
  x$date <- as.Date(x$date)
  
  return(x)
  
}