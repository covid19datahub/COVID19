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
  url <- "https://www.datos.gov.co/resource/gt2j-8ykr.csv"
  
  x   <- read.csv(url, sep = ',')
  
  #' Create the column 'date'.
  x$date <- as.Date(x$fecha_de_notificaci_n, format = "%Y-%m-%d")

  head(x)
 

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

