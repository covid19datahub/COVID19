#' Data Science for Social Impact research group, University of Pretoria
#'
#' Data source for: South Africa
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#'
#' @source https://github.com/dsfsi/covid19za
#'
#' @keywords internal
#'
github.dsfsi.covid19za <- function(level){
  if(!level %in% 1:2) return(NULL)
  
  # download
  baseurl  <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_provincial_cumulative_timeline_"
  x.cases  <- read.csv(paste0(baseurl, "confirmed.csv"))
  x.deaths <- read.csv(paste0(baseurl, "deaths.csv"))
  x.tests  <- read.csv(paste0(baseurl, "testing.csv"))
  x.recov  <- read.csv(paste0(baseurl, "recoveries.csv"))
  
  if(level==1)
    cols <- "total"
  if(level==2)
    cols <- c("EC","FS","GP","KZN","LP","MP","NC","NW","WC")
  
  # cases
  x.cases <- x.cases %>%
    select(c("date", cols)) %>%
    pivot_longer(cols = all_of(cols), names_to = "state", values_to = "confirmed")
  
  # deaths
  x.deaths <- x.deaths %>%
    select(c("date", cols)) %>%
    pivot_longer(cols = all_of(cols), names_to = "state", values_to = "deaths")
  
  # cases
  x.tests <- x.tests %>%
    select(c("date", cols)) %>%
    pivot_longer(cols = all_of(cols), names_to = "state", values_to = "tests")
  
  # cases
  x.recov <- x.recov %>%
    select(c("date", cols)) %>%
    pivot_longer(cols = all_of(cols), names_to = "state", values_to = "recovered")
  
  # merge
  by <- c("date", "state")
  x <- x.cases %>%
    full_join(x.deaths, by = by) %>%
    full_join(x.recov, by = by) %>%
    full_join(x.tests, by = by)
  
  # convert date
  x$date <- as.Date(x$date, format = "%d-%m-%Y")
  
  return(x)
}
