#' Portugal
#'
#' @source \url{`r repo("PRT")`}
#' 
PRT <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("PRT", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(level = level, country = "Portugal") %>% 
      select(-recovered)
    x1 <- x1[x1$date <= "2023-03-10",]
    
    # use vintage data because half of recovered data disappeared from github.cssegisanddata.covid19
    x2 <- covid19datahub.io(iso = "PRT", level) %>% 
      select(date, recovered)
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    x3 <- who.int(level = 1, id = "PT")
    x3 <- x3[x3$date > "2023-03-10",]
    
    #' - \href{`r repo("github.dssgpt.covid19ptdata")`}{Data Science for Social Good Portugal}:
    #' hospitalizations,
    #' intensive care.
    #'
    x4 <- github.dssgpt.covid19ptdata(level = level) %>%
      select(-c("confirmed", "deaths", "recovered"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x5 <- ourworldindata.org(id = "PRT") %>%
      select(-c("hosp", "icu"))
    
    # merge
    x <- bind_rows(x1, x3) %>%
      full_join(x2, by = "date") %>%
      full_join(x4, by = "date") %>%
      full_join(x5, by = "date")
      
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("PRT", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.dssgpt.covid19ptdata")`}{Data Science for Social Good Portugal}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- github.dssgpt.covid19ptdata(level = level)
    x$id <- id(x$region, iso = "PRT", ds = "github.dssgpt.covid19ptdata", level = level)
    
  }
  
  return(x)
}
