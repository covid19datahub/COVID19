#' Australia
#'
#' @source \url{`r repo("AUS")`}
#' 
AUS <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("AUS", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.m3it.covid19data")`}{Matt Bolton}:
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
    x <- github.m3it.covid19data(level = level)
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("AUS", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.m3it.covid19data")`}{Matt Bolton}:
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
    x <- github.m3it.covid19data(level = level)
    x$id <- id(x$administrative_area_level_2, iso = "AUS", ds = "github.m3it.covid19data", level = level)
    
  }
  
  return(x)
}
