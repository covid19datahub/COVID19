#' Moldova
#'
#' @source \url{`r repo("MDA")`}
#' 
MDA <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("MDA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Moldova")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x2 <- who.int(level, id = "MD") 
    x2 <- x2[x2$date > "2023-03-10",]
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- ourworldindata.org(id = "MDA") %>% 
      select(-tests)
    
    # use vintage data because test data from ourworldindata.org is no longer available
    x4 <- covid19datahub.io(iso = "MDA", level) %>% 
      select(date, tests)
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>% 
      full_join(x4, by = "date")
    
  }
  
  return(x)
}
