#' Czech Republic
#'
#' @source \url{`r repo("CZE")`}
#' 
CZE <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("CZE", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("mzcr.cz")`}{Ministry of Health of the Czech Republic}:
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
    x <- mzcr.cz(level = level)
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("CZE", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("mzcr.cz")`}{Ministry of Health of the Czech Republic}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- mzcr.cz(level = level)
    x$id <- id(x$nuts, iso = "CZE", ds = "mzcr.cz", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("CZE", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("mzcr.cz")`}{Ministry of Health of the Czech Republic}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests.
    #'
    x <- mzcr.cz(level = level)
    x$id <- id(x$lau, iso = "CZE", ds = "mzcr.cz", level = level)
    
  }
  
  return(x)
}
