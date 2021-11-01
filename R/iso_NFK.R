#' Norfolk Island
#'
#' @source \url{`r repo("NFK")`}
#' 
NFK <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("NFK", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x <- github.cssegisanddata.covid19(country = "Norfolk Island")
    
  }
  
  return(x)
}
