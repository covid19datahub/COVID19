#' Jersey
#'
#' @source \url{`r repo("JEY")`}
#' 
JEY <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("JEY", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- github.cssegisanddata.covid19(country = "United Kingdom", state = "Jersey", level = 2)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- ourworldindata.org(id = "JEY")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  return(x)
}
