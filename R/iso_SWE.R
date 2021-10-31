#' Sweden
#'
#' @source \url{`r repo("SWE")`}
#' 
SWE <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("SWE", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("arcgis.se")`}{Public Health Agency of Sweden}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- arcgis.se(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "SWE")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("SWE", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("arcgis.se")`}{Public Health Agency of Sweden}:
    #' confirmed cases.
    #'
    x <- arcgis.se(level = level)
    x$id <- id(x$state, iso = "SWE", ds = "arcgis.se", level = level) 
    
  }
  
  return(x)
}
