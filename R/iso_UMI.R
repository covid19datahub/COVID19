#' United States Minor Outlying Islands
#'
#' @source \url{`r repo("UMI")`}
#' 
UMI <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("UMI", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x <- github.cssegisanddata.covid19(country = "United States Minor Outlying Islands")
    
  }
  
  return(x)
}
