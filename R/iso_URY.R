#' Uruguay
#'
#' @source \url{`r repo("URY")`}
#' 
URY <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("URY", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Uruguay")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x2 <- who.int(level, id = "UY")
    x2 <- x2[x2$date > "2023-03-10",]
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- ourworldindata.org(id = "URY")
    
    # use vintage data because some daily data from ourworldindata.org is no longer available
    x4 <- covid19datahub.io(iso = "URY", level) %>% 
      select(date, vaccines, people_vaccinated, people_fully_vaccinated)
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>% 
      full_join(x4, by = "date") %>% 
      mutate(vaccines = coalesce(vaccines.x, vaccines.y), 
             people_vaccinated = coalesce(people_vaccinated.x, people_vaccinated.y), 
             people_fully_vaccinated = coalesce(people_fully_vaccinated.x, people_fully_vaccinated.y))
    
  }
  
  return(x)
}
