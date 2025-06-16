#' Ireland
#'
#' @source \url{`r repo("IRL")`}
#' 
IRL <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("IRL", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("geohive.ie")`}{Health Protection Surveillance Centre (HPSC) and Health Service Executive (HSE)}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- geohive.ie(level = level)
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x2 <- who.int(level, id = "IE")
    x2 <- x2[x2$date > "2023-11-14",]
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x3 <- github.cssegisanddata.covid19(country = "Ireland") %>%
      select(-c("confirmed", "deaths"))
    
    # merge
    x <- full_join(x1, x2, by = "date") %>% 
      full_join(x3, by = "date") %>% 
      mutate(confirmed = coalesce(confirmed.x, confirmed.y),
             deaths = coalesce(deaths.x, deaths.y))
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("IRL", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("geohive.ie")`}{Health Protection Surveillance Centre (HPSC) and Health Service Executive (HSE)}:
    #' confirmed cases.
    x <- geohive.ie(level = level)
    x$id <- id(x$county_id, iso = "IRL", ds = "geohive.ie", level = level)
    
  }
  
  return(x)
}
