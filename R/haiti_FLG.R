COLGOV <- function(cache, id= null){
  #'
  #' NEW DATA SOURCE TEMPLATE
  #' This is a template to extend this package with a new data source
  #'
  #' Copy this template in a new file
  #' Rename the file with the name of the data source
  #' Rename this function with the name of the data source
  #'
  #' The function must include the argument 'cache'. See:
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/covid19.R
  #' The function can include additional arguments
  #' The function must return a data.frame
  #'
  #' Examples:
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/openZH.R
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/pcmdpc.R
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/jhuCSSE.R
  #'
  #' @keywords internal
  #'


  #' Download and cache the data.
  #' For more information on the Colombian Government API see https://dev.socrata.com/foundry/www.datos.gov.co/gt2j-8ykr
  #' 
  #' 
  url <- "https://proxy.hxlstandard.org/data/738954/download/haiti-covid-19-subnational-data.csv"
  
  x   <- read.csv(url, sep = ',')[-1,]
  
  #' Create the column 'date'.
  x$Date <- as.Date(x$Date, format = "%d-%m-%Y")

  x[,c(ncol(x), ncol(x)-1, ncol(x)-2)] <- NULL
  
  
  
  library(plyr)
  
  x <- rexname(x, c("DÃ.partement"="state", "Confirmed.cases"="confirmed"))
  
  return(x)
  
  
 

  #' Include additional columns, including but not limited to:
  #' https://github.com/emanuele-guidotti/COVID19#dataset
  #'
  #' your code here...
  #'


  #' Extra
  #' filter the data, clean the data, etc.
  #'
  #' your code here...
  #'


  #' return

}

