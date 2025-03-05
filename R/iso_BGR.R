#' Bulgaria
#'
#' @source \url{`r repo("BGR")`}
#' 
BGR <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("BGR", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Bulgaria")  
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level = 1, id = "BG") %>% 
      filter(date > "2023-03-09")
    
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #'  
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- covid19datahub.io(iso = "BGR", level) %>% 
      filter(date <= "2022-11-13") %>%
      select(date, vaccines, people_vaccinated, people_fully_vaccinated, hosp, icu)
    
    x4 <- ourworldindata.org(id = "BGR")  %>% 
      filter(date >"2022-11-13")
    
    # merge
    x <- bind_rows(x1, x2) %>% 
      full_join(bind_rows(x3, x4), by = "date")
    
  }
  
  return(x)
}
