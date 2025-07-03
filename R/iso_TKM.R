#' Turkmenistan
#'
#' @source \url{`r repo("TKM")`}
#' 
TKM <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("TKM", 1)`
  #' 
  if(level==1){

    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases.
    #' 
    x1 <- who.int(level, id = "TM")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- ourworldindata.org(id = "TKM")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  return(x)
}
