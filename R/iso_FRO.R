#' Faroe Islands
#' 
#' Data available at level 1 (nation).
#' 
#' @section Data sources:
#' 
#' \bold{Level 1.}
#' \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (confirmed cases, recovered, deaths); 
#' \href{`r repo("ourworldindata.org")`}{Our World in Data} 
#' (tests, hospitalizations, vaccines);
#' \href{https://data.worldbank.org/indicator/SP.POP.TOTL}{World Bank Open Data}
#' (population 2018).
#' 
#' @source `r repo("FRO")`
#' 
#' @concept level 1
#' 
FRO <- function(level, ...){
  if(level>1) return(NULL)
  
  # confirmed, recovered, deaths
  x1 <- github.cssegisanddata.covid19(file = "global", level = 2, state = "Faroe Islands")
  
  # tests, hospitalizations, vaccines
  x2 <- ourworldindata.org(id = "FRO")
  
  # merge
  x <- merge(x1, x2, by = "date", all = TRUE)
  
  return(x)
  
}
