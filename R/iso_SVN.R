#' Slovenia
#'
#' @source \url{`r repo("SVN")`}
#' 
SVN <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("SVN", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gov.si")`}{Ministry of Health and National Institute for Public health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- gov.si(level = level)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "Slovenia") %>%
      select(-c("confirmed", "deaths"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- ourworldindata.org(id = "SVN") %>%
      select(-c("tests", "hosp", "icu"))
    
    # merge
    x <- x1 %>%
      full_join(x2, by = "date") %>%
      full_join(x3, by = "date")
    
  }
  
  return(x)
}
