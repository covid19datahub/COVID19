govuk <- function(cache,level){

  # source
  url  <- "https://coronavirus.data.gov.uk/downloads/csv/coronavirus-cases_latest.csv"
  
  # download
  x <- read.csv(url, cache=cache)
  
  # level
  if(level==1)
    x <- x[x$Area.type=="Nation",]
  if(level==2)
    x <- x[x$Area.type=="Region",]
  if(level==3)
    x <- x[x$Area.type=="Upper tier local authority",]
  
  # format 
  x$date <- as.Date(x$Specimen.date)
  x <- reduce(x, c(
    'date',
    'Area.name'                      = 'name',       
    'Area.code'                      = 'code',
    'Cumulative.lab.confirmed.cases' = 'confirmed'
  ))
  
  return(x) 

}


