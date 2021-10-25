#' Austria
#'
#' @source \url{`r repo("AUT")`}
#' 
AUT <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("AUT", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gv.at")`}{Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x <- gv.at(level = level)
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("AUT", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("gv.at")`}{Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x <- gv.at(level = level)
    x$id <- id(x$state_id, iso = "AUT", ds = "gv.at", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("AUT", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("gv.at")`}{Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x <- gv.at(level = level)
    x$id <- id(x$city_id, iso = "AUT", ds = "gv.at", level = level)
    
  }
  
  return(x)
}
