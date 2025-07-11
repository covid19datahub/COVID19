#' United Kingdom
#'
#' @source \url{`r repo("GBR")`}
#' 
GBR <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("GBR", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gov.uk")`}{UK Health Security Agency}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' patients requiring ventilation.
    #'
    
    # use vintage data because previous file is not available
    # new gov.uk file only covers England from 2024 onwards
    x1 <- covid19datahub.io(iso = "GBR", level) %>% 
      select(-confirmed, -deaths, -recovered)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "United Kingdom") %>% 
      filter(date <= "2023-03-10")
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x3 <- who.int(level = 1, id = "GB") %>% 
      filter(date > "2023-03-10")

    # merge
    x <- bind_rows(x2, x3) %>%
      full_join(x1, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("GBR", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("gov.uk")`}{UK Health Security Agency}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' patients requiring ventilation.
    #'
    
    # use vintage data because previous file is not available
    # new gov.uk file doesn't not cover the individual nations of the UK
    x <- covid19datahub.io(iso = "GBR", level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("GBR", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("gov.uk")`}{UK Health Security Agency}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    
    # use vintage data because previous file is not available
    # new gov.uk file includes different local administrative areas
    x <- covid19datahub.io(iso = "GBR", level) %>%
      # drop vaccines because they seem wrong and they have also been 
      # removed from the archive data at
      # https://ukhsa-dashboard.data.gov.uk/covid-19-archive-data-download
      select(-vaccines)
    
  }
  
  return(x)
}
