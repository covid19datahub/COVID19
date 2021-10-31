#' Ukraine
#'
#' @source \url{`r repo("UKR")`}
#' 
UKR <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("UKR", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Ukraine")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "UKR")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("UKR", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.cssegisanddata.covid19unified")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x <- github.cssegisanddata.covid19unified(iso = "UKR", level = level)
    
  }
  
  return(x)
}
