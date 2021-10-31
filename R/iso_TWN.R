#' Taiwan
#'
#' @source \url{`r repo("TWN")`}
#' 
TWN <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("TWN", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gov.tw")`}{Ministry of Health and Welfare of Taiwan}:
    #' confirmed cases,
    #' tests.
    #'
    x1 <- gov.tw(level = level)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' deaths,
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "Taiwan*") %>%
      select(-c("confirmed"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "TWN") %>%
      select(-c("tests"))
    
    # merge
    x <- x1 %>%
      full_join(x2, by = "date") %>%
      full_join(x3, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("TWN", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("gov.tw")`}{Ministry of Health and Welfare of Taiwan}:
    #' confirmed cases.
    #'
    x <- gov.tw(level = level)
    x$id <- id(x$county, iso = "TWN", ds = "gov.tw", level = level)
    
  }
  
  return(x)
}
