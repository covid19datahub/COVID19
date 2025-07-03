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
humdata.ht <- function(level){
  if(level!=2) return(NULL)

  # download
  url <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vTqVOxCSrhEiZ_CRME3Xqhu_DWZv74FvrvOr77rIXOlorClEi0huwVKxXXcVr2hn8pml82tlwmf59UX/pub?output=xlsx"
  x <- read.excel(url, sheet = 1)
  
  # formatting 
  x <- map_data(x[-1,], c(
    'Département'       = 'state',
    'Date'              = 'date',
    'Cumulative cases'  = 'confirmed',
    'Cumulative Deaths' = 'deaths'
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
      deaths =  as.integer(gsub(",", "", deaths))) %>%
    # drop duplicates
    distinct(state, date, .keep_all = TRUE)
  
  # convert to date
  x$date <- as.Date(
    ifelse(
      grepl("^[0-9]+(\\.0)?$", x$date),
      as.numeric(x$date) + as.numeric(as.Date("1899-12-30")),
      as.numeric(as.Date(x$date, "%d-%m-%Y"))),
    origin = "1970-01-01")
  
  return(x)
}
