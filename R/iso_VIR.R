#' Virgin Islands, U.S.
#'
#' @source \url{`r repo("VIR")`}
#' 
VIR <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("VIR", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.nytimes.covid19data")`}{The New York Times}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- github.nytimes.covid19data(fips = "78", level = 2)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "Virgin Islands", level = 2)
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  return(x)
}
