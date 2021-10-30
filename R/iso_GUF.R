#' French Guiana
#'
#' @source \url{`r repo("GUF")`}
#' 
GUF <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("GUF", 1)`
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
    x <- gouv.fr(dep = "973", level = 3)
    
  }
  
  return(x)
}
