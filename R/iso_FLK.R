#' Falkland Islands
#' 
#' Data available at level 1 (nation).
#' 
#' @section Data sources:
#' 
#' \bold{Level 1.}
#' \href{`r repo("jhucsse_git")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (confirmed cases, recovered, deaths); 
#' \href{`r repo("ourworldindata_org")`}{Our World in Data} 
#' (tests, hospitalizations, vaccines);
#' \href{https://data.worldbank.org/indicator/SP.POP.TOTL}{World Bank Open Data}
#' (population 2018).
#' 
#' @source `r repo("FLK")`
#' 
FLK <- function(level, ...){
  if(level>1) return(NULL)
  
  # confirmed, recovered, deaths
  x1 <- jhucsse_git(file = "global", level = 2, state = "Falkland Islands (Malvinas)")
  
  # tests, hospitalizations, vaccines
  x2 <- ourworldindata_org(id = "FLK")
  
  # merge
  x <- merge(x1, x2, by = "date", all = TRUE)
  
  return(x)
  
}
