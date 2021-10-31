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
    
    #' - \href{`r repo("github.dssgpt.covid19ptdata")`}{Data Science for Social Good Portugal}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- github.dssgpt.covid19ptdata(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- ourworldindata.org(id = "PRT") %>%
      select(-c("hosp", "icu"))
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
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
