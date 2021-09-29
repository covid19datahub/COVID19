BRA <- function(level, cache) {
  
  x <- covid19br_git(level = level, cache = cache)
  
  if(level==2)
    x$id <- id(x$state, iso = "BRA", ds = "covid19br_git", level = level)
  
  if(level==3){  
    
    # Espirito Santo (additional data for tests and recovered)
    # Check agreement with https://coronavirus.es.gov.br/painel-covid-19-es
    # y <- gov_br_es(level = level, cache = cache)
    # y$id <- id(y$Municipio, iso = "BRA", ds = "gov_br_es", level = level)

    # vaccines
    v <- gov_br(level = level, cache = cache)
    v$id <- id(v$city, iso = "BRA", ds = "gov_br", level = level)
    
    # merge
    x$id <- id(x$code, iso = "BRA", ds = "covid19br_git", level = level)
    x <- x %>%
      # dplyr::filter(state != "ES") %>%
      # dplyr::bind_rows(y) %>%
      dplyr::left_join(v, by = c("id", "date"))
    
  }
  
  # return
  return(x)
  
}