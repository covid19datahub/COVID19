#' Ministry of Public Health and Population of Haiti
#'
#' Data source for: Haiti
#'
#' @param level 2
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#'
#' @source https://data.humdata.org/dataset/haiti-covid-19-subnational-cases
#'
#' @keywords internal
#'
humdata.org <- function(level){
  if(level!=2) return(NULL)

  # download
  url <- "https://proxy.hxlstandard.org/data/738954/download/haiti-covid-19-subnational-data.csv"
  x   <- read.csv(url)
  
  # formatting 
  x <- map_data(x[-1,], c(
    'Département'       = 'state',
    'Date'              = 'date',
    'Cumulative.cases'  = 'confirmed',
    'Cumulative.Deaths' = 'deaths'
  ))
  
  # sanitize
  x <- x %>%
    mutate(
      # states to lower
      state = tolower(state),
      # fix names
      state = replace(state, state=="grand anse", "grandanse"),
      state = replace(state, state=="quest", "ouest"),
      # convert to integers
      confirmed = as.integer(gsub(",", "", confirmed)),
      deaths =  as.integer(gsub(",", "", deaths)),
      # convert to date
      date = as.Date(date, format = "%d-%m-%Y")) %>%
    # drop duplicates
    distinct(state, date, .keep_all = TRUE)
  
  return(x)
}
