#' China
#'
#' @source \url{`r repo("CHN")`}
#' 
CHN <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("CHN", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- who.int(id = "CN")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "CHN")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  return(x)
}
