#' Robert Koch Institut
#'
#' Data source for: Germany
#'
#' @param level 1, 2, 3
#' 
#' @section Level 1:
#' - confirmed cases,
#' - deaths,
#' - recovered
#' 
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://github.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland
#'
#' @keywords internal
#'
github.robertkochinstitut.covid19impfungenindeutschland <- function(level){
  if(!level %in% 1:3) return(NULL)
  
    # download
    url <- "https://github.com/robert-koch-institut/SARS-CoV-2-Infektionen_in_Deutschland/raw/refs/heads/main/Aktuell_Deutschland_SarsCov2_Infektionen.csv"
    x <- data.table::fread(url, showProgress = FALSE)
    
    # format
    x <- map_data(x, c(
      'Meldedatum'      = 'date',
      'IdLandkreis'     = 'id_district',
      'AnzahlFall'      = 'confirmed',
      'AnzahlTodesfall' = 'deaths',
      'AnzahlGenesen'   = 'recovered',
      'NeuerFall'       = 'confirmed_status',
      'NeuerTodesfall'  = 'deaths_status',
      'NeuGenesen'      = 'recovered_status'
    ))
    # create id_state based on the first digit of the district code
    x$id_state <- as.integer(substr(as.character(x$id_district), 1, ifelse(nchar(x$id_district) == 4, 1, 2)))
    
    # convert date type
    x <- x[!is.na(x$date),]
    x$date <- as.Date(x$date, format = "%Y/%m/%d")
    
    # group key
    if(level == 1) 
      by <- NULL
    if(level == 2) 
      by <- c('id_state')
    if(level == 3) 
      by <- c('id_district')
    
    # The German data is slightly odd. It is a CSV file which is updated daily,
    # the 'status' flags is the status of the entry on the day the file was
    # updated. The flags mean:
    #                                     
    #    1 - cdr was only added today (as in the day the file was created)
    #    0 - cdr was added to yesterdays file, or before, but NOT today
    #   -1 - cd will be removed tomorrow but is still present today, exclude it
    #   -9 - not applicable (e.g. recovered_status=-9 on a death)
    #
    # So, basically just exclude anything with a negative value, but only for that
    # specific column type.
    # 
    # (Abbreviated case/death/recovery as cdr)
    x <- x %>%
      # drop negative counts
      mutate(
        confirmed = replace(confirmed, confirmed < 0, 0),
        deaths    = replace(deaths, deaths < 0, 0),
        recovered = replace(recovered, recovered < 0, 0)) %>%
      # group by date and admin area
      group_by_at(c('date', by)) %>%
      # compute total counts
      summarise(
        confirmed = sum(confirmed),
        deaths    = sum(deaths),
        recovered = sum(recovered)) %>%
      # group by admin area
      group_by_at(by) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        confirmed = cumsum(confirmed),
        deaths    = cumsum(deaths),
        recovered = cumsum(recovered))
 
  if(level==2){
    
    # download
    url <- "https://raw.githubusercontent.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland/refs/heads/main/Deutschland_Bundeslaender_COVID-19-Impfungen.csv"
    
    x.vacc <- read.csv(url)
    
    # format
    x.vacc  <- map_data(x.vacc, c(
      "Impfdatum" = "date",
      "BundeslandId_Impfort" = "id_state",
      "Impfstoff" = "type",
      "Impfserie" = "dose",
      "Anzahl" = "n"
    ))
    
    # convert date type
    x.vacc$date <- as.Date(x.vacc$date)
    
    # vaccines
    x.vacc  <- x.vacc %>%
      # remove undefined region
      filter(id_state!=17) %>%
      # create oneshot column
      mutate(is_oneshot = type=="Janssen") %>%
      # for each date and region
      group_by(date, id_state) %>%
      # compute total doses and people vaccinated
      summarise(
        vaccines = sum(n),
        people_vaccinated = sum(n[dose==1]),
        people_fully_vaccinated = sum(n[(dose==1 & is_oneshot) | (dose==2 & !is_oneshot)])) %>%
      # group by region
      group_by(id_state) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))
    
    # merge
    x <- full_join(x, x.vacc, by = c("date", by))
  }
  
  if(level==3){
    
    # download
    url <- "https://raw.githubusercontent.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland/refs/heads/main/Deutschland_Landkreise_COVID-19-Impfungen.csv"
    x.vacc <- read.csv(url)
    
    # format
    x.vacc  <- map_data(x.vacc, c(
      "Impfdatum" = "date",
      "LandkreisId_Impfort" = "id_district",
      "Impfschutz" = "type",
      "Anzahl" = "n"
    ))
    
    # convert date type
    x.vacc$date <- as.Date(x.vacc$date)
    
    # vaccines
    x.vacc <- x.vacc %>%
      # keep only valid admin areas (5 digits)
      # drop undefined (17000) and Berlin region (11000)
      filter(grepl("^\\d{5}$", id_district) & !id_district %in% c("11000", "17000")) %>%
      # id to integer
      mutate(id_district = as.integer(id_district)) %>%
      # for each admin area and date
      group_by(id_district, date) %>%
      # compute total doses and people vaccinated
      summarize(
        vaccines = sum(n),
        people_vaccinated = sum(n[type==1]),
        people_fully_vaccinated = sum(n[type==2])) %>%
      # group by admin area
      group_by(id_district) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))
    
    # merge
    x <- full_join(x, x.vacc, by = c("date", by))
  }

  # convert date
  x$date <- as.Date(x$date)
  
  return(x) 
}
