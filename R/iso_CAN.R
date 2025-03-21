#' Canada
#'
#' @source \url{`r repo("CAN")`}
#' 
CAN <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("CAN", 1)`
  #' 
  if(level==1){
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #'  
    #' - \href{`r repo("canada.ca")`}{Public Health Agency of Canada}:
    #' confirmed cases,
    #' deaths,
    #' tests.
    #'
    x1 <- canada.ca(level = level) %>%
      select(-c("vaccines", "people_vaccinated", "people_fully_vaccinated"))
    
    x2 <- covid19datahub.io(iso = "CAN", level) %>% 
      filter(date >= "2024-05-25") %>% 
      select(date, confirmed)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "CAN") %>%
      select(-c("tests"))
    
    # merge
    x <- full_join(x1, x2, by = "date") %>% 
      full_join(x3, by = "date") %>%
      mutate(confirmed = coalesce(confirmed.y, confirmed.x))
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("CAN", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("canada.ca")`}{Public Health Agency of Canada}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- canada.ca(level = level)
    x$id <- id(x$id, iso = "CAN", ds = "canada.ca", level = level)
    
  }
  
  return(x)
}
