#' United States
#' 
#' The data are available at 3 different levels of granularity:
#' level 1 (nation), level 2 (states), and level 3 (counties).
#' 
#' @section Data sources:
#' 
#' \bold{Level 1.} 
#' \href{`r repo("jhucsse_git")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (confirmed cases, recovered, deaths, population); 
#' \href{`r repo("ourworldindata_org")`}{Our World in Data} 
#' (hospitalizations, intensive care, test, vaccines).
#' 
#' \bold{Level 2.} 
#' \href{`r repo("fun_name")`}{Data Source Name}
#' (variables, separated, by, comma); 
#' \href{`r repo("fun_name_2")`}{Data Source Name 2} 
#' (variables, separated, by, comma).
#' 
#' @concept official
#' 
USA <- function(level, cache){
  if(level>3) return(NULL)

  if(level==1){
    
    # fallback to worldwide data. 
    x <- NULL
    
  }
  
  if(level==2){

    # tests, hospitalized and icu
    h <- healthdata_gov(level = level, cache = cache)
    h$id <- id(h$state, iso = "USA", ds = "healthdata_gov", level = level)
    
    # confirmed and deaths 
    n <- nytimes_git(cache = cache, level = level)
    n$id <- id(n$fips, iso = "USA", ds = "nytimes_git", level = level)
    
    # recovered and vent
    r <- covidtracking_com(cache = cache) 
    r$id <- id(r$state, iso = "USA", ds = "covidtracking_com", level = level)
    
    # vaccines
    v <- owidus_git(cache = cache)
    v$id <- id(v$state, iso = "USA", ds = "owidus_git", level = level)
    
    # merge
    key <- c("date", "id")
    x <- n[,c(key, "confirmed", "deaths")] %>%
      dplyr::full_join(h[,c(key, "tests", "hosp", "icu")], by = key) %>%
      dplyr::full_join(v[,c(key, "vaccines")], by = key) %>%
      dplyr::full_join(r[,c(key, "recovered", "vent")], by = key)
    
  }
  
  if(level==3){
    
    # confirmed and deaths
    x <- nytimes_git(cache = cache, level = level)
    x$id <- id(x$fips, iso = "USA", ds = "nytimes_git", level = level)
    
  }

  return(x)

}
