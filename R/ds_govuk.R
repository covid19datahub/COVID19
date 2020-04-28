govuk <- function(cache,level){

# source
url  <- "https://coronavirus.data.gov.uk/downloads/csv/coronavirus-cases_latest.csv"

# download
x   <- read.csv(url, cache=cache)

#Format 
x$date <- as.Date(x$Specimen.date)

x$level <- 0
x$level[x$Area.type=="Nation"] <- 1
x$level[x$Area.type=="Region"] <- 2
x$level[x$Area.type=="Upper tier local authority"] <- 3

x$confirmed <- x$Cumulative.lab.confirmed.cases
x      <- subset(x,level=level) #maybe could be dropped..

x$id <- x$Area.code

return(x) #Not clear...

}


