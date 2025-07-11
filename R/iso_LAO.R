#' Laos
#'
#' @source \url{`r repo("LAO")`}
#' 
LAO <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("LAO", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Laos") %>% 
      select(-confirmed, -deaths)

    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x2 <- who.int(level, id = "LA")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- ourworldindata.org(id = "LAO")
    
    # merge
    x <- full_join(x1, x2, by = "date")%>%
      full_join(x3, by = "date")
    
  }
  
  return(x)
}
