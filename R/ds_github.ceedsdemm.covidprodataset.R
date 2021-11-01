#' Centre of Excellence in Economics and Data Science, University of Milan
#'
#' Data source for: Italy
#'
#' @param level 3
#'
#' @section Level 3:
#' - deaths
#'
#' @source https://github.com/CEEDS-DEMM/COVID-Pro-Dataset
#'
#' @keywords internal
#'
github.ceedsdemm.covidprodataset <- function(level){
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
