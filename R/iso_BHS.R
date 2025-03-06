#' Bahamas
#'
#' @source \url{`r repo("BHS")`}
#' 
BHS <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("BHS", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Bahamas")
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level = 1, id = "BS") %>% 
      filter(date > "2023-03-09")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "BHS")
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date")
    
  }
  
  return(x)
}
