#' Estonia
#'
#' @source \url{`r repo("EST")`}
#' 
EST <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("EST", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Estonia")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x2 <- who.int(level, id = "EE")
    x2 <- x2[x2$date > "2023-03-10",]
    
    # use vintage data because some icu daily data from ourworldindata.org is no longer available 
    x3 <- covid19datahub.io(iso = "EST", level) %>% 
      select(date, icu)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x4 <- ourworldindata.org(id = "EST")
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>% 
      full_join(x4, by = "date") %>% 
      mutate(icu = ifelse(date >= "2022-10-09", icu.y, icu.x))
  }

  return(x)
}
