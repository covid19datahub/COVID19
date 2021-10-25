#' United States
#' 
#' Data available at level 1 (nation), level 2 (states), and level 3 (counties).
#' 
#' @section Data sources:
#' 
#' \bold{Level 1.} 
#' \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (confirmed cases, recovered, deaths); 
#' \href{`r repo("ourworldindata.org")`}{Our World in Data} 
#' (tests, hospitalizations, vaccines);
#' \href{https://data.worldbank.org/indicator/SP.POP.TOTL}{World Bank Open Data}
#' (population 2018).
#' 
#' \bold{Level 2.} 
#' \href{`r repo("github.nytimes.covid19data")`}{The New York Times} 
#' (confirmed cases, deaths);
#' \href{`r repo("healthdata_gov")`}{U.S. Department of Health & Human Services}
#' (tests, hospitalized patients and intensive care); 
#' \href{`r repo("covidtracking_com")`}{The Covid Tracking Project}
#' (patients requiring ventilation, recovered); 
#' \href{`r repo("ourworldindata.org")`}{Our World in Data} 
#' (vaccines);
#' \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (population 2020). 
#' 
#' \bold{Level 3.} 
#' \href{`r repo("github.nytimes.covid19data")`}{The New York Times} 
#' (confirmed cases, deaths);
#' \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}
#' (population 2020).
#' 
#' @source `r repo("USA")`
#' 
#' @concept level 1
#' @concept level 2
#' @concept level 3
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
    n <- github.nytimes.covid19data(level = level)
    n$id <- id(n$fips, iso = "USA", ds = "github.nytimes.covid19data", level = level)
    
    # recovered and vent
    r <- covidtracking_com(level = level) 
    r$id <- id(r$state, iso = "USA", ds = "covidtracking_com", level = level)
    
    # vaccines
    v <- ourworldindata.org(level = level)
    v$id <- id(v$state, iso = "USA", ds = "ourworldindata.org", level = level)
    
    # merge
    key <- c("date", "id")
    x <- n[,c(key, "confirmed", "deaths")] %>%
      dplyr::full_join(h[,c(key, "tests", "hosp", "icu")], by = key) %>%
      dplyr::full_join(v[,c(key, "vaccines")], by = key) %>%
      dplyr::full_join(r[,c(key, "recovered", "vent")], by = key)
    
  }
  
  if(level==3){
    
    # confirmed and deaths
    x <- github.nytimes.covid19data(level = level)
    x$id <- id(x$fips, iso = "USA", ds = "github.nytimes.covid19data", level = level)
    
  }

  return(x)

}
