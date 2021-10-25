#' Puerto Rico
#' 
#' Data available at level 1 (nation).
#' 
#' @section Data sources:
#' 
#' \bold{Level 1.}
#' \href{`r repo("nytimes_git")`}{The New York Times}
#' (confirmed cases, deaths); 
#' \href{`r repo("ourworldindata.org")`}{Our World in Data} 
#' (tests, hospitalizations, vaccines);
#' \href{https://data.worldbank.org/indicator/SP.POP.TOTL}{World Bank Open Data}
#' (population 2018).
#' 
#' @source `r repo("PRI")`
#' 
#' @concept level 1
#' 
PRI <- function(level, ...){
  if(level>1) return(NULL)
  
  # confirmed and deaths
  x1 <- nytimes_git(level = 2, fips = "72")
  
  # tests, hospitalizations, vaccines
  x2 <- ourworldindata.org(id = "PRI")
  
  # merge
  x <- merge(x1, x2, by = "date", all = TRUE)
  
  return(x)
  
}
