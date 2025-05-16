#' Kosovo
#'
#' @source \url{`r repo("RKS")`}
#' 
RKS <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("RKS", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Kosovo")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x2 <- who.int(level, id = "XK") 
    x2 <- x2[x2$date > "2023-03-10",]
    
    # merge
    x <- bind_rows(x1, x2)
  }
  
  return(x)
}
