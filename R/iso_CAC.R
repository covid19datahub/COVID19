#' Cruise Ship Costa Atlantica
#'
#' @source \url{`r repo("CAC")`}
#' 
CAC <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("CAC", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.swsoyee.2019ncovjapan")`}{Su Wei}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations.
    #'
    x <- github.swsoyee.2019ncovjapan(id = "Costa Atlantica", level = 1) %>%
      filter(date >= "2020-04-21" & date <= "2020-07-10")
    
  }
  
  return(x)
}
