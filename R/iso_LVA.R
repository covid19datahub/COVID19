#' Latvia
#'
#' @source \url{`r repo("LVA")`}
#' 
LVA <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("LVA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gov.lv")`}{Center for Disease Prevention and Control}:
    #' confirmed cases,
    #' deaths,
    #' tests.
    #'
    x1 <- gov.lv(level = level)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "Latvia") %>%
      select(-c("confirmed", "deaths"))
          
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "LVA") %>%
      select(-c("tests"))
    
    # merge
    x <- x1 %>% 
      full_join(x2, by = "date") %>%
      full_join(x3, by = "date")
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("LVA", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("gov.lv")`}{Center for Disease Prevention and Control}:
    #' confirmed cases.
    #'
    x <- gov.lv(level = level)
    x$id <- id(x$atvk, iso = "LVA", ds = "gov.lv", level = level)
    
  }
  
  return(x)
}
