#' Afghanistan Ministry of Health
#'
#' Data source for: Afghanistan
#'
#' @param level 2
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#'
#' @source https://data.humdata.org/dataset/afghanistan-covid-19-statistics-per-province
#'
#' @keywords internal
#'
humdata.af <- function(level){
  if(level!=2) return(NULL)
  
  # download
  url <- "https://docs.google.com/spreadsheets/d/1F-AMEDtqK78EA6LYME2oOsWQsgJi4CT3V_G4Uo-47Rg/export?format=csv"
  x <- read.csv(url)
  
  # formatting 
  x <- map_data(x[-1,], c(
    'Province'   = 'state',
    'Date'       = 'date',
    'Cases'      = 'confirmed',
    'Deaths'     = 'deaths',
    'Recoveries' = 'recovered',
    'Tests'      = 'tests'
  ))
  
  # sanitize
  x <- x %>%
    mutate(
      # states to lower
      state = gsub("[^a-z]+province.*$", "", tolower(x$state)),
      # fix names
      state = replace(state, state=="dykundi", "daykundi"),
      state = replace(state, state=="hirat", "herat"),
      state = replace(state, state=="jawzjan", "jowzjan"),
      state = replace(state, state=="nimroz", "nimruz"),
      state = replace(state, state=="nooristan", "nuristan"),
      state = replace(state, state=="paktya", "paktia"),
      state = replace(state, state=="panjshir", "panjsher"),
      state = replace(state, grepl("^sar[^a-z].*p[ou]l$", state), "sar-e pol"),
      # convert to integers
      confirmed = as.integer(gsub("[^0-9]", "", confirmed)),
      deaths =  as.integer(gsub("[^0-9]", "", deaths)),
      recovered =  as.integer(gsub("[^0-9]", "", recovered)),
      tests =  as.integer(gsub("[^0-9]", "", tests)),
      # convert to date
      date = as.Date(date, format = "%Y-%m-%d"))
  
  # remove decreasing cumulative counts
  # the data are not clean and these issues are most likely manual entry mistakes
  x <- drop_decreasing(x, by = "state", cols = c("confirmed", "deaths", "recovered", "tests"), k = 1:7, strict = FALSE)
  
  return(x)
}
