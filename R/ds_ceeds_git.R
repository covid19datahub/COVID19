#' Centre of Excellence in Economics and Data Science, University of Milan
#' 
#' Imports Italian deaths at the province level from the Centre of Excellence 
#' in Economics and Data Science, University of Milan.
#' 
#' @source 
#' https://github.com/CEEDS-DEMM/COVID-Pro-Dataset
#' 
#' @keywords internal
#' 
ceeds_git <- function(level){
  if(level!=3) return(NULL)
                      
  # source
  url  <- "https://raw.githubusercontent.com/CEEDS-DEMM/COVID-Pro-Dataset/master/deathsItaProv.csv"

  # download
  x   <- read.csv(url)
  
  # formatting
  x <- map_data(x, c(
    'Date'       = 'date',
    'id_prov'    = 'city_code',
    'Tot_deaths' = 'deaths'
  ))
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")

  # return
  return(x)

}
