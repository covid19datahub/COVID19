#' Northern Mariana Islands
#'
#' @source \url{`r repo("MNP")`}
#' 
MNP <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("MNP", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.nytimes.covid19data")`}{The New York Times}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- github.nytimes.covid19data(fips = "69", level = 2)
    
  }
  
  return(x)
}
