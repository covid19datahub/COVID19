#' Robert Koch Institut
#'
#' Data source for: Germany
#'
#' @param level 2, 3
#'
#' @section Level 2:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 3:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://github.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland
#'
#' @keywords internal
#'
github.robertkochinstitut.covid19impfungenindeutschland <- function(level){
  if(!level %in% 2:3) return(NULL)
  
  if(level==2){
    
    # download
    url <- "https://raw.githubusercontent.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland/master/Aktuell_Deutschland_Bundeslaender_COVID-19-Impfungen.csv"
    x <- read.csv(url)
    
    # format
    x <- map_data(x, c(
      "Impfdatum" = "date",
      "BundeslandId_Impfort" = "id",
      "Impfstoff" = "type",
      "Impfserie" = "dose",
      "Anzahl" = "n"
    ))
    
    # vaccines
    x <- x %>%
      # remove undefined region
      filter(id!=17) %>%
      # create oneshot column
      mutate(is_oneshot = type=="Janssen") %>%
      # for each date and region
      group_by(date, id) %>%
      # compute total doses and people vaccinated
      summarise(
        vaccines = sum(n),
        people_vaccinated = sum(n[dose==1]),
        people_fully_vaccinated = sum(n[(dose==1 & is_oneshot) | (dose==2 & !is_oneshot)])) %>%
      # group by region
      group_by(id) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))
    
  }
  
  if(level==3){
    
    # download
    url <- "https://raw.githubusercontent.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland/master/Aktuell_Deutschland_Landkreise_COVID-19-Impfungen.csv"
    x <- read.csv(url)
    
    # format
    x <- map_data(x, c(
      "Impfdatum" = "date",
      "LandkreisId_Impfort" = "id",
      "Impfschutz" = "type",
      "Anzahl" = "n"
    ))
    
    # vaccines
    x <- x %>%
      # keep only valid admin areas (5 digits)
      # drop undefined (17000) and Berlin region (11000)
      filter(grepl("^\\d{5}$", id) & !id %in% c("11000", "17000")) %>%
      # id to integer
      mutate(id = as.integer(id)) %>%
      # for each admin area and date
      group_by(id, date) %>%
      # compute total doses and people vaccinated
      summarize(
        vaccines = sum(n),
        people_vaccinated = sum(n[type==1]),
        people_fully_vaccinated = sum(n[type==2])) %>%
      # group by admin area
      group_by(id) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))
    
  }
  
  # convert date
  x$date <- as.Date(x$date)
  
  return(x) 
}
