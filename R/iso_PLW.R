#' Palau
#'
#' @source \url{`r repo("PLW")`}
#' 
PLW <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("PLW", 1)`
  #' 
  if(level==1){

    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x1 <- who.int(level, id = "PW") 
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests.
    #'
    x2 <- ourworldindata.org(id = "PLW")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  return(x)
}
