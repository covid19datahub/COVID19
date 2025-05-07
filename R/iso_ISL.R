#' Iceland
#'
#' @source \url{`r repo("ISL")`}
#' 
ISL <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("ISL", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Iceland")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases.
    #' 
    x2 <- who.int(level, id = "IS") %>% 
      select(-deaths)
    x2 <- x2[x2$date > "2023-03-10",]
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "ISL") %>% 
      select(-hosp, -icu)
    
    # use vintage data because hosp, icu  data from ourworldindata.org are no longer available
    x4 <- covid19datahub.io(iso = "ISL", level) %>% 
      select(date, hosp, icu)
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>%
      full_join(x4, by = "date")
    
  }
  
  return(x)
}
