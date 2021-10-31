#' Lithuania
#'
#' @source \url{`r repo("LTU")`}
#' 
LTU <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("LTU", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.mpiktas.covid19lt")`}{Vaidotas Zemlys-Balevicius}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x <- github.mpiktas.covid19lt(level = level)
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("LTU", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.mpiktas.covid19lt")`}{Vaidotas Zemlys-Balevicius}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- github.mpiktas.covid19lt(level = level)
    x$id <- id(x$admin2, iso = "LTU", ds = "github.mpiktas.covid19lt", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("LTU", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("github.mpiktas.covid19lt")`}{Vaidotas Zemlys-Balevicius}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- github.mpiktas.covid19lt(level = level)
    x$id <- id(x$admin3, iso = "LTU", ds = "github.mpiktas.covid19lt", level = level)
    
  }
  
  return(x)
}
