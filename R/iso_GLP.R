#' Guadeloupe
#'
#' @source \url{`r repo("GLP")`}
#' 
GLP <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("GLP", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gouv.fr")`}{Santé Publique France}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x <- gouv.fr(dep = "971", level = 3)
    
  }
  
  return(x)
}
