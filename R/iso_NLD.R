#' Netherlands
#'
#' @source \url{`r repo("NLD")`}
#' 
NLD <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("NLD", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("rivm.nl")`}{National Institute for Public Health and the Environment}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- rivm.nl(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "NLD")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("NLD", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("rivm.nl")`}{National Institute for Public Health and the Environment}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- rivm.nl(level = level)
    x$id <- id(x$province, iso = "NLD", ds = "rivm.nl", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("NLD", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("rivm.nl")`}{National Institute for Public Health and the Environment}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- rivm.nl(level = level)
    x$id <- id(x$municipality, iso = "NLD", ds = "rivm.nl", level = level)
    
  }
  
  return(x)
}
