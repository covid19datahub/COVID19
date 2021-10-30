#' Wikipedia
#'
#' Data source for: Diamond Princess (Cruise Ship)
#'
#' @param level 1
#'
#' @section Level 1:
#' - confirmed cases
#' - tests
#'
#' @source https://en.wikipedia.org/wiki/COVID-19_pandemic_on_Diamond_Princess
#'
#' @keywords internal
#'
wikipedia.dp <- function(level) {
  if(level!=1) return(NULL)

  # data downloaded from the table "Confirmed cases on Diamond Princess" at 
  # https://en.wikipedia.org/wiki/COVID-19_pandemic_on_Diamond_Princess
  x <- extdata("ds/DPC.csv") %>%
    mutate(date = as.Date(date))
  
  return(x)
}
