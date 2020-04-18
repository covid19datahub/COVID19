
library(rjson)
library(rvest)

mzcr <- function(cache, ...){
  #'
  #' NEW DATA SOURCE TEMPLATE
  #' This is a template to extend this package with a new data source
  #'
  #' Copy this template in a new file
  #' Rename the file with the name of the data source
  #' Rename this function with the name of the data source
  #'
  #' The function must include the argument 'cache'. See:
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/covid19.R
  #' The function can include additional arguments
  #' The function must return a data.frame
  #'
  #' Examples:
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/openZH.R
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/pcmdpc.R
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/jhuCSSE.R
  #'
  #' @keywords internal
  #'
  
  #' Download and cache the data.
  # sources
  # mzcr - Ministery of Health of Czech Republic
  mzcr.covid.api <- "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19"
  mzcr.covid.url <- "https://onemocneni-aktualne.mzcr.cz/covid-19"
  
  # number of tests
  tests.url <- sprintf("%s/testy.csv", mzcr.covid.api)
  tests.raw <- read.csv(tests.url) # use cache here
  # columns: date, daily tests, cumulative tests
  tests <- data.frame(date=as.Date(tests.raw[,1],format="%Y-%m-%d"),
                      tests=tests.raw[,2] )
  
  # number of infected
  confirmed.url <- sprintf("%s/nakaza.csv", mzcr.covid.api)
  confirmed.raw <- read.csv(confirmed.url) # use cache here
  # columns: date, daily confirmed, cumulative confirmed
  confirmed <- data.frame(date=as.Date(confirmed.raw[,1],format="%Y-%m-%d"),
                          confirmed=confirmed.raw[,2])
  
  # --- webscrape ---
  # number of deaths
  page.html <- xml2::read_html(mzcr.covid.url)
  # JSON in HTML attribute to R list 
  deaths.json <- page.html %>% html_node("#js-total-died-table-data") %>% xml_attr("data-table")
  deaths.webdata <- fromJSON(deaths.json)
  # collect from JSON nested array into single sequence
  collectJSONArrayElements <- function(sequence, item_index) {
    return(sapply(1:length(sequence),
                  function(i) sequence[[i]][[item_index]]))
  }
  # iterate dates and deaths
  # columns: date, deaths, cumulative deaths
  deaths.dates <- as.Date(collectJSONArrayElements(deaths.webdata$body, 1), format="%d.%m.%Y")
  deaths.deaths <- as.integer(collectJSONArrayElements(deaths.webdata$body, 2))
  deaths <- data.frame(date = deaths.dates, deaths = deaths.deaths)
  
  
  # number of hospitalizations/cured
  hospitalizations.webdata <- xml2::read_html(mzcr.covid.url) %>%
    html_nodes(".equipmentTable") %>% .[[1]] %>% # first table of page
    html_table() # table to dataframe
  hospitalizations.webdata[,1] <- as.Date(hospitalizations.webdata[,1], format="%d.%m.%Y")
  # columns: date, hospitalized, critical, percentage of critical, recovered, percentage of recovered
  # note: recovered are including the one who went to home care
  # note: base of percentages is number of hospitalized people
  hospitalized <- data.frame(date=hospitalizations.webdata[,1],
                             hospitalized=hospitalizations.webdata[,2])
  critical <- data.frame(date=hospitalizations.webdata[,1],
                         critical=hospitalizations.webdata[,3])
  recovered <- data.frame(date=hospitalizations.webdata[,1],
                          recovered=hospitalizations.webdata[,5])

  
  #' TODO: I was not able to get following
  #'   * icu
  #'   * vent
  #'   * driving
  #'   * walking
  #'   * transit
  #'   * ...
  
  # Other things that can be acquired
  # pseudoanonymized list of infected people
  #people.url <- sprintf("%s/osoby.csv", mzcr.url)
  #people <- read.csv(people.url)
  #colnames(people) <- c("date","age","gender","region","infected_abroad","country_of_infection")
  #people$date <- as.Date(people$date, format="%Y-%m-%d")
  #levels(people$gender)[levels(people$gender) == "Z"] <- "F"
  #people$infected_abroad <- !is.na(people$infected_abroad)
  
  # protection material distribution to regions
  #material.url <- sprintf("%s/pomucky.csv", mzcr.url)
  #material <- read.csv(material.url)
  
  #' Include additional columns, including but not limited to:
  #' https://github.com/emanuele-guidotti/COVID19#dataset
  saturate.0 <- function(seq) { 
    seq[seq < 0] = 0
    return(seq)
  }
  cumsum.full <- function(seq) cumsum(saturate.0( c(seq[1],diff(seq)) ))
  #' Create the column 'date'.
  # outer joins by date
  x <- merge(tests, confirmed, by=c("date"), all=T)
  x <- merge(x, deaths, by=c("date"), all=T)
  x <- merge(x, hospitalized, by=c("date"), all=T)
  x <- merge(x, critical, by=c("date"), all=T)
  x <- merge(x, recovered, by=c("date"), all=T)
  # replace missing values
  x[is.na(x$deaths),]$deaths <- 0
  x[is.na(x$hospitalized),]$hospitalized <- 0
  x[is.na(x$critical),]$critical <- 0
  x[is.na(x$recovered),]$recovered <- 0
  x[is.na(x$confirmed),]$confirmed <- 0
  x[is.na(x$tests),]$tests <- 0
  # cumulative sums
  x$tests <- cumsum(x$tests)
  x$confirmed <- cumsum(x$confirmed)
  x$deaths <- cumsum(x$deaths)
  x$recovered <- cumsum.full(x$recovered)
  x$hospitalized <- cumsum.full(x$hospitalized)

  #' Extra
  #' filter the data, clean the data, etc.
  #' ...
  
  #' return
  return(x)
  
}

#mzcr(NA)
