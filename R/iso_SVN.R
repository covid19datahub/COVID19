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
    #' deaths.
    #'
    x1 <- gov.si(level = level) %>% 
      select(-c("tests", "hosp", "icu"))
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x2 <- who.int(level = level, id = "SI")
    x2 <- x2[x2$date > "2022-03-10",]
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x3 <- github.cssegisanddata.covid19(country = "Slovenia") %>%
      select(-c("confirmed", "deaths"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #' 
    x4 <- ourworldindata.org(id = "SVN") %>% 
      select(-tests)
    
    #' - \href{`r repo("github.sledilnik.data")`}{Sledilnik}:
    #' tests.
    #'
    x5 <- github.sledilnik.data(level = level)
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>%
      full_join(x4, by = "date") %>% 
      full_join(x5, by = "date")
    
  }
  
  return(x)
}
