#' United States
#' 
#' Data available at level 1 (nation), level 2 (states), and level 3 (counties).
#' 
#' @section Data sources:
#' 
#' \bold{Level 1.} 
#' \href{`r repo("jhucsse_git")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (confirmed cases, recovered, deaths); 
#' \href{`r repo("ourworldindata_org")`}{Our World in Data} 
#' (tests, hospitalizations, vaccines);
#' \href{https://data.worldbank.org/indicator/SP.POP.TOTL}{World Bank Open Data}
#' (population 2018).
#' 
#' \bold{Level 2.} 
#' \href{`r repo("nytimes_git")`}{The New York Times} 
#' (confirmed cases, deaths);
#' \href{`r repo("healthdata_gov")`}{U.S. Department of Health & Human Services}
#' (tests, hospitalized patients and intensive care); 
#' \href{`r repo("covidtracking_com")`}{The Covid Tracking Project}
#' (patients requiring ventilation, recovered); 
#' \href{`r repo("owidus_git")`}{Our World in Data} 
#' (vaccines);
#' \href{`r repo("jhucsse_git")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (population 2020). 
#' 
#' \bold{Level 3.} 
#' \href{`r repo("nytimes_git")`}{The New York Times} 
#' (confirmed cases, deaths);
#' \href{`r repo("jhucsse_git")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (population 2020).
#' 
#' @source `r repo("USA")`
#' 
USA <- function(level, ...){
  if(level>3) return(NULL)

  if(level==1){
    
    # fallback to worldwide data. 
    x <- NULL
    
  }
  
  if(level==2){

    # tests, hospitalized and icu
    h <- healthdata_gov(level = level)
    h$id <- id(h$state, iso = "USA", ds = "healthdata_gov", level = level)
    
    # confirmed and deaths 
    n <- nytimes_git(level = level)
    n$id <- id(n$fips, iso = "USA", ds = "nytimes_git", level = level)
    
    # recovered and vent
    r <- covidtracking_com(level = level) 
    r$id <- id(r$state, iso = "USA", ds = "covidtracking_com", level = level)
    
    # vaccines
    v <- owidus_git(level = level)
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
    x <- nytimes_git(level = level)
    x$id <- id(x$fips, iso = "USA", ds = "nytimes_git", level = level)
    
  }

  return(x)

}
