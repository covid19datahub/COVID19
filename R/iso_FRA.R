#' France
#'
#' @source \url{`r repo("FRA")`}
#' 
FRA <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("FRA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gouv.fr")`}{Santé Publique France}:
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- gouv.fr(level = level)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "France") %>%
      select(-c("deaths"))
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("FRA", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("gouv.fr")`}{Santé Publique France}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x <- gouv.fr(level = level)
    x$id <- id(x$reg, iso = "FRA", ds = "gouv.fr", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("FRA", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("gouv.fr")`}{Santé Publique France}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x <- gouv.fr(level = level)
    x$id <- id(x$dep, iso = "FRA", ds = "gouv.fr", level = level)
    
  }
  
  return(x)
}
