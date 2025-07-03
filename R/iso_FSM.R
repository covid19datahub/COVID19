#' Micronesia
#'
#' @source \url{`r repo("FSM")`}
#' 
FSM <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("FSM", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x1 <- who.int(level, id = "FM")

    #' - \href{`r repo("sprep.org")`}{Secretariat of the Pacific Regional Environment Programme}:
    #' total vaccine doses administered,
    #' people vaccinated,
    #' people fully vaccinated.
    #'
    x2 <- sprep.org(id = "FM")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  return(x)
}
