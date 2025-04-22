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
    
    # use vintage data because daily data disappeared from github.cssegisanddata.covid19
    # and test file from gov.tw is no longer available
    x2 <- covid19datahub.io(iso = "TWN", level) %>% 
      select(date, deaths, recovered, tests)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- ourworldindata.org(id = "TWN") %>%
      select(-c("tests", "hosp", "icu"))
    
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
