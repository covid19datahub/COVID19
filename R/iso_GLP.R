#' Guadeloupe
#' 
#' Data available at level 1 (nation).
#' 
#' @section Data sources:
#' 
#' \bold{Level 1.}
#' \href{`r repo("gouv.fr")`}{Santé publique France}
#' (confirmed cases, deaths, tests, hospitalizations, vaccines); 
#' \href{https://data.worldbank.org/indicator/SP.POP.TOTL}{World Bank Open Data}
#' (population 2018).
#' 
#' @source `r repo("GLP")`
#' 
#' @concept level 1
#' 
GLP <- function(level, ...){
  if(level>1) return(NULL)
  
  # confirmed, deaths, tests, hospitalizations, vaccines
  x <- gouv.fr(level = 3, dep = "971")  
  
  return(x)
  
}