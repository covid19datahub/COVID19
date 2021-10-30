#' Guadeloupe
#'
#' @source \url{`r repo("GLP")`}
#' 
GLP <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("GLP", 1)`
  #' 
  if(level==1){
    
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
    x1 <- gouv.fr(dep = "971", level = 3)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "Guadeloupe") %>%
      select(-c("confirmed", "deaths"))
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  return(x)
}
