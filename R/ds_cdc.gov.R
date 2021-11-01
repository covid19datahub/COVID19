#' Centers for Disease Control and Prevention
#'
#' Data source for: United States
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 2:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 3:
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://data.cdc.gov/browse?q=COVID-19%20Vaccination&sortBy=relevance
#'
#' @keywords internal
#'
cdc.gov <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  if(level==1 | level==2){
   
    # vaccines
    # see https://data.cdc.gov/d/rh2h-3yt2
    url <- "https://data.cdc.gov/api/views/rh2h-3yt2/rows.csv?accessType=DOWNLOAD"
    x <- read.csv(url)
    
    # format
    x <- map_data(x, c(
      "date_type" = "type",
      "Date" = "date",
      "Location" = "state",
      "Administered_Cumulative" = "vaccines",
      "Admin_Dose_1_Cumulative" = "people_vaccinated",
      "Series_Complete_Cumulative" = "people_fully_vaccinated"
    ))
    
    # select data by date of vaccine administration
    x <- filter(x, type=="Admin")
    
    # filter by level
    if(level==1)
      x <- filter(x, state=="US")
    if(level==2)
      x <- filter(x, !is.na(state) & !state %in% c("US", "FM", "RP", "MH"))
    
    # convert date
    x$date <- as.Date(x$date, format = "%m/%d/%Y")
    
  }
  
  if(level==3){
    
    # vaccines
    # see https://data.cdc.gov/d/8xkx-amqh
    url <- "https://data.cdc.gov/api/views/8xkx-amqh/rows.csv?accessType=DOWNLOAD"
    x <- data.table::fread(url, showProgress = FALSE)
    
    # format
    x <- map_data(x, c(
      "Date" = "date",
      "FIPS" = "fips",
      "Series_Complete_Yes" = "people_fully_vaccinated",
      "Administered_Dose1_Recip" = "people_vaccinated"
    ))
    
    # clean
    x <- x %>%
      # drop unassigned and Guam
      filter(fips!="UNK" & fips!="66010") %>%
      # fips to integers
      mutate(fips = as.integer(fips)) %>%
      # drop duplicated rows
      distinct() %>%
      # standardize fips
      mutate(        
        # map "Yakutat" and "Hoonah-Angoon" to "Yakutat plus Hoonah-Angoon"
        fips = replace(fips, fips %in% c(2105, 2282), 2998),
        # map "Bristol Bay" and "Lake and Peninsula" to "Bristol Bay plus Lake and Peninsula"
        fips = replace(fips, fips %in% c(2164, 2060), 2997),
        # map New York boroughs to New York City
        fips = replace(fips, fips %in% c(36081, 36005, 36085, 36047), 36061)) %>%
      # for each date and fips
      group_by(date, fips) %>%
      # compute total counts
      summarise(
        people_vaccinated = sum(people_vaccinated),
        people_fully_vaccinated = sum(people_fully_vaccinated))
    
    # convert date
    x$date <- as.Date(x$date, format = "%m/%d/%Y")
    
  }
  
  return(x)
}
