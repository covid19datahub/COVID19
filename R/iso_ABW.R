#' Aruba
#'
#' @source \url{`r repo("ABW")`}
#' 
ABW <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("ABW", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(state = "Aruba", level = 2)
    
    x1$deaths[x1$date == "2022-04-20"] <- NA # removing the anomalous death count
    
    last_dates <- x1 %>%
      summarise(
        conf_date = max(date[!is.na(confirmed)], na.rm = TRUE), # most recent date where conf are available
        deaths_date = max(date[!is.na(deaths)], na.rm = TRUE)) # most recent date where deaths are available
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    
    x2 <- who.int(level = 1, id = "AW") %>%
      filter(
        (date > last_dates$conf_date) |
        (date > last_dates$deaths_date))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "ABW") %>%
      select(-c("confirmed", "deaths", "tests"))
    
    # merge
    x <- full_join(x1, x2, by = c("date")) %>%
      mutate(
        confirmed = coalesce(confirmed.x, confirmed.y),
        deaths = coalesce(deaths.x, deaths.y)) %>%
      full_join(x3, by = "date")
    
  }
  
  return(x)
}
