#' United States
#'
#' @source \url{`r repo("USA")`}
#' 
USA <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("USA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.nytimes.covid19data")`}{The New York Times}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- github.nytimes.covid19data(level = level)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "United States") %>%
      select(-c("confirmed", "deaths"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "USA") %>%
      select(-c("vaccines", "people_vaccinated", "people_fully_vaccinated"))
    
    #' - \href{`r repo("cdc.gov")`}{Centers for Disease Control and Prevention}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x4 <- cdc.gov(level = level)
    
    # merge
    x <- x1 %>%
      full_join(x2, by = "date") %>%
      full_join(x3, by = "date") %>%
      full_join(x4, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("USA", 2)`
  #' 
  if(level==2){

    #' - \href{`r repo("github.nytimes.covid19data")`}{The New York Times}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- github.nytimes.covid19data(level = level)
    x1$id <- id(x1$fips, iso = "USA", ds = "github.nytimes.covid19data", level = level)
    
    #' - \href{`r repo("healthdata.gov")`}{U.S. Department of Health & Human Services}:
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- healthdata.gov(level = level)
    x2$id <- id(x2$state, iso = "USA", ds = "healthdata.gov", level = level)
    
    #' - \href{`r repo("covidtracking.com")`}{The COVID Tracking Project}:
    #' recovered,
    #' patients requiring ventilation.
    #'
    x3 <- covidtracking.com(level = level) %>%
      select(-c("confirmed", "deaths", "tests", "hosp", "icu")) %>%
      mutate(id = id(state, iso = "USA", ds = "covidtracking.com", level = level))

    #' - \href{`r repo("cdc.gov")`}{Centers for Disease Control and Prevention}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x4 <- cdc.gov(level = level)
    x4$id <- id(x4$state, iso = "USA", ds = "cdc.gov", level = level)
    
    # merge
    x <- x1 %>%
      full_join(x2, by = c("id", "date")) %>%
      full_join(x3, by = c("id", "date")) %>%
      full_join(x4, by = c("id", "date"))
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("USA", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("github.nytimes.covid19data")`}{The New York Times}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- github.nytimes.covid19data(level = level)
    x1$id <- id(x1$fips, iso = "USA", ds = "github.nytimes.covid19data", level = level)
    
    #' - \href{`r repo("cdc.gov")`}{Centers for Disease Control and Prevention}:
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- cdc.gov(level = level)
    x2$id <- id(x2$fips, iso = "USA", ds = "cdc.gov", level = level)
    
    # merge
    x <- full_join(x1, x2, by = c("id", "date"))
    
  }
  
  return(x)
}
