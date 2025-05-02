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
   
    #' - \href{`r repo("github.italia.covid19opendatavaccini")`}{Commissario straordinario per l'emergenza Covid-19, Presidenza del Consiglio dei Ministri}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- github.italia.covid19opendatavaccini(level = level)
    
    # use vintage data because as of this date github.italia.covid19opendatavaccini stopped specifying the dose type 
    # a new variable "d"-unspecified was introduced
    x3 <- covid19datahub.io(iso = "ITA", level) %>% 
      select(date, people_vaccinated, people_fully_vaccinated) %>% 
      filter(date >= "2023-09-11")
    
    # merge
    x <- full_join(x1, x2, by = "date") %>% 
      full_join(x3, by = "date") %>% 
      mutate(people_vaccinated = coalesce(people_vaccinated.y, people_vaccinated.x),
             people_fully_vaccinated = coalesce(people_fully_vaccinated.y, people_fully_vaccinated.x))
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
    
    #' - \href{`r repo("github.italia.covid19opendatavaccini")`}{Commissario straordinario per l'emergenza Covid-19, Presidenza del Consiglio dei Ministri}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #' 
    x2 <- github.italia.covid19opendatavaccini(level = level)
    x2$id <- id(x2$state, iso = "ITA", ds = "github.italia.covid19opendatavaccini", level = level)
    
    # use vintage data because as of this date github.italia.covid19opendatavaccini stopped specifying the dose type 
    # a new variable "d"-unspecified was introduced
    x3 <- covid19datahub.io(iso = "ITA", level) %>% 
      select(date, id, vaccines, people_vaccinated, people_fully_vaccinated) %>% 
      filter(date >= "2023-09-11")
    
    # merge
    x <- full_join(x1, x2, by = c("date", "id")) %>% 
      full_join(x3, by = c("date", "id")) %>% 
      mutate(vaccines = coalesce(vaccines.y, vaccines.x), 
             people_vaccinated = coalesce(people_vaccinated.y, people_vaccinated.x),
             people_fully_vaccinated = coalesce(people_fully_vaccinated.y, people_fully_vaccinated.x))
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
