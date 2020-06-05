gov_uk <- function(cache,level){

  # source
  url.cases  <- "https://coronavirus.data.gov.uk/downloads/csv/coronavirus-cases_latest.csv"
  url.death  <- "https://coronavirus.data.gov.uk/downloads/csv/coronavirus-deaths_latest.csv"
  
  # download
  x <- read.csv(url.cases, cache = cache)
  y <- read.csv(url.death, cache = cache)
  
  # merge
  x <- merge(x, y, by.x = c("Area.code","Specimen.date"), by.y = c("Area.code", "Reporting.date"), all = TRUE)
  
  # format 
  x <- map_data(x, c(
    'Specimen.date'                  = 'date',
    'Area.name'                      = 'name',  
    'Area.type'                      = 'type',
    'Area.code'                      = 'code',
    'Cumulative.lab.confirmed.cases' = 'confirmed',
    'Cumulative.deaths'              = 'deaths'
  ))
  
  # level
  if(level==1)
    x <- x[x$type=="UK",]
  if(level==2)
    x <- x[x$type %in% c("Nation","Region"),]
  if(level==3)
    x <- x[x$type=="Upper tier local authority",]
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x) 

}


