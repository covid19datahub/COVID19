#' Guam
#' 
#' Data available at level 1 (nation).
#' 
#' @section Data sources:
#' 
#' \bold{Level 1.}
#' \href{`r repo("nytimes_git")`}{The New York Times}
#' (confirmed cases, deaths); 
#' \href{`r repo("ourworldindata_org")`}{Our World in Data} 
#' (tests, hospitalizations, vaccines);
#' \href{https://data.worldbank.org/indicator/SP.POP.TOTL}{World Bank Open Data}
#' (population 2018).
#' 
#' @source `r repo("GUM")`
#' 
#' @concept level 1
#' 
GUM <- function(level, ...){
  if(level>1) return(NULL)
  
  # confirmed and deaths
  x1 <- nytimes_git(level = 2, fips = "66")
  
  # tests, hospitalizations, vaccines
  x2 <- ourworldindata_org(id = "GUM")
  
  # merge
  x <- merge(x1, x2, by = "date", all = TRUE)
  
  return(x)
  
}
