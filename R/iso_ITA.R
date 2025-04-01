#' Italy
#'
#' @source \url{`r repo("ITA")`}
#' 
ITA <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("ITA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.pcmdpc.covid19")`}{Ministero della Salute}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- github.pcmdpc.covid19(level = level)
    
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #'  
    #' - \href{`r repo("github.italia.covid19opendatavaccini")`}{Commissario straordinario per l'emergenza Covid-19, Presidenza del Consiglio dei Ministri}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- covid19datahub.io(iso = "ITA", level) %>% 
      select(date, people_vaccinated, people_fully_vaccinated) %>% 
      filter(date >= "2023-09-11")
    
    x3 <- github.italia.covid19opendatavaccini(level = level)
    
    # merge
    x <- full_join(x1, x2, by = "date") %>% 
      full_join(x3, by = "date") %>% 
      mutate(people_vaccinated = coalesce(people_vaccinated.x, people_vaccinated.y),
             people_fully_vaccinated = coalesce(people_fully_vaccinated.x, people_fully_vaccinated.y))
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("ITA", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.pcmdpc.covid19")`}{Ministero della Salute}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- github.pcmdpc.covid19(level = level)
    x1$id <- id(x1$state, iso = "ITA", ds = "github.pcmdpc.covid19", level = level)
    
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #'  
    #' - \href{`r repo("github.italia.covid19opendatavaccini")`}{Commissario straordinario per l'emergenza Covid-19, Presidenza del Consiglio dei Ministri}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    
    x2 <- covid19datahub.io(iso = "ITA", level) %>% 
      select(date, id, vaccines, people_vaccinated, people_fully_vaccinated) %>% 
      filter(date >= "2023-09-11")
    
    x3 <- github.italia.covid19opendatavaccini(level = level)
    x3$id <- id(x3$state, iso = "ITA", ds = "github.italia.covid19opendatavaccini", level = level)
    
    # merge
    x <- full_join(x1, x2, by = c("date", "id")) %>% 
      full_join(x3, by = c("date", "id")) %>% 
      mutate(vaccines = coalesce(vaccines.x, vaccines.y), 
             people_vaccinated = coalesce(people_vaccinated.x, people_vaccinated.y),
             people_fully_vaccinated = coalesce(people_fully_vaccinated.x, people_fully_vaccinated.y))
    
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("ITA", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("github.pcmdpc.covid19")`}{Ministero della Salute}:
    #' confirmed cases.
    #'
    x <- github.pcmdpc.covid19(level = level)
    x$id <- id(x$city, iso = "ITA", ds = "github.pcmdpc.covid19", level = level)
    
  }
  
  return(x)
}
