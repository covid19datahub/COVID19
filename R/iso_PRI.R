#' Puerto Rico
#'
#' @source \url{`r repo("PRI")`}
#' 
PRI <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("PRI", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.nytimes.covid19data")`}{The New York Times}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- github.nytimes.covid19data(fips = "72", level = 2)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "PRI")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  return(x)
}
