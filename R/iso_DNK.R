#' Denmark
#'
#' @source \url{`r repo("DNK")`}
#' 
DNK <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("DNK", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Denmark")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "DNK")
   
    # merge
    x <- full_join(x1, x2, by = "date")
     
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("DNK", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("ssi.dk")`}{Statens Serum Institut}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations.
    #'
    x <- ssi.dk(level = level)
    x$id <- id(x$region, iso = "DNK", ds = "ssi.dk", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("DNK", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("ssi.dk")`}{Statens Serum Institut}:
    #' confirmed cases,
    #' tests,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- ssi.dk(level = level)
    x$id <- id(x$code, iso = "DNK", ds = "ssi.dk", level = level)
    
  }
  
  return(x)
}
