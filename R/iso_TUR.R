#' Turkey
#'
#' @source \url{`r repo("TUR")`}
#' 
TUR <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("TUR", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Turkey")
    
    #' - \href{`r repo("github.ozanerturk.covid19turkeyapi")`}{Ozan Erturk}:
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x2 <- github.ozanerturk.covid19turkeyapi(level = level) %>%
      select(-c("confirmed", "deaths", "recovered", "tests"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations.
    #'
    x3 <- ourworldindata.org(id = "TUR") %>%
      select(-c("icu"))
    
    # merge
    x <- x1 %>%
      full_join(x2, by = "date") %>%
      full_join(x3, by = "date")
    
  }
  
  return(x)
}
