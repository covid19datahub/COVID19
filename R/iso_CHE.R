#' Switzerland
#'
#' @source \url{`r repo("CHE")`}
#' 
CHE <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("CHE", 1)`
  #' 
  if(level==1){
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #'  
    #' - \href{`r repo("admin.ch")`}{Federal Office of Public Health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- admin.ch(state = "CH", level = level)
    
    #' people fully vaccinated.
    #' 
    x2 <- covid19datahub.io(iso = "CHE", level) %>% 
      select(date, people_fully_vaccinated)
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x3 <- who.int(level = 1, id = "CH") %>% 
      filter(date > "2023-11-28")
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x4 <- github.cssegisanddata.covid19(country = "Switzerland") %>% 
      select(-c("confirmed", "deaths"))
    
    # merge 
    x <- bind_rows(x1, x3) %>% 
      full_join(x2, by = "date") %>% 
      full_join(x4, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("CHE", 2)`
  #' 
  if(level==2){
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #'  
    #' - \href{`r repo("admin.ch")`}{Federal Office of Public Health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- admin.ch(state = "CH", level = level)
    x1$id <- id(x1$code, iso = "CHE", ds = "admin.ch", level = level)
    
    #' people fully vaccinated.
    #' 
    x2 <- covid19datahub.io(iso = "CHE", level) %>% 
      select(date, id, people_fully_vaccinated)
    
    #' - \href{`r repo("github.openzh.covid19")`}{Specialist Unit for Open Government Data Canton of Zurich}:
    #' recovered,
    #' patients requiring ventilation.
    #'
    x3 <- github.openzh.covid19(state = "CH", level = level) %>% 
      select(-c("confirmed", "deaths", "tests", "hosp", "icu")) %>%
      mutate(id = id(code, iso = "CHE", ds = "github.openzh.covid19", level = level))
    
    # merge
    x <- full_join(x1, x2, by = c("id", "date")) %>% 
      full_join(x3, by = c("id", "date"))
    
  }
  
  return(x)
}
