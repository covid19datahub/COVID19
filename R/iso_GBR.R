#' United Kingdom
#'
#' @source \url{`r repo("GBR")`}
#' 
GBR <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("GBR", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gov.uk")`}{UK Health Security Agency}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' patients requiring ventilation.
    #'
    x <- gov.uk(level = level)
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("GBR", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("gov.uk")`}{UK Health Security Agency}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' patients requiring ventilation.
    #'
    x <- gov.uk(level = level)
    x$id <- id(x$code, iso = "GBR", ds = "gov.uk", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("GBR", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("gov.uk")`}{UK Health Security Agency}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' patients requiring ventilation.
    #'
    x <- gov.uk(level = level)
    x$id <- id(x$code, iso = "GBR", ds = "gov.uk", level = level)
    
  }
  
  return(x)
}
