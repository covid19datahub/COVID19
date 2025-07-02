#' Statens Serum Institut
#'
#' Data source for: Denmark
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - tests
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - tests
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#'
#' @section Level 3:
#' - confirmed cases
#' - tests
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://covid19.ssi.dk/overvagningsdata
#'
#' @keywords internal
#'
ssi.dk <- function(level) {
  if(!level %in% 1:3) return(NULL)

  # function to scrape the url of the latest data file
  get_url <- function(webpage, baseurl){
    html <- httr::GET(webpage)
    data <- httr::content(html)
    data <- as.character(data)
    pattern <- paste0(baseurl, "-\\d{8}[-\\_a-z0-9]*")
    m <- regexpr(pattern, data, ignore.case = TRUE)
    regmatches(data, m)
  }
  
  # download vaccines  
  webpage <- "https://covid19.ssi.dk/overvagningsdata/download-fil-med-vaccinationsdata"
  baseurl <- "https://files.ssi.dk/covid19/overvagning/zipfil/vaccinationsdata-dashboard-covid19"
  zip.vacc <- tempfile()
  url <- get_url(webpage = webpage, baseurl = baseurl)
  download.file(url, zip.vacc, quiet = TRUE, mode = "wb")  
  
  # temp dir to unzip
  dir <- tempdir()
  
  if(level %in% 1:2) {
    # download cases
    webpage <- "https://covid19.ssi.dk/overvagningsdata/download-fil-med-overvaagningdata"
    baseurl <- "https://files.ssi.dk/covid19/overvagning/dashboard/overvaagningsdata-dashboard-covid19"
    zip.cases <- tempfile()
    url <- get_url(webpage = webpage, baseurl = baseurl)
    download.file(url, zip.cases, quiet = TRUE, mode = "wb")  
    
    # read cases and deaths
    file <- "Regionalt_DB/03_bekraeftede_tilfaelde_doede_indlagte_pr_dag_pr_koen.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.cases <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    # format cases
    x.cases <- map_data(x.cases, c(
      "Region" = "region",
      "Prøvetagningsdato" = "date",
      "Døde" = "deaths",
      "Bekræftede.tilfælde.i.alt" = "confirmed",
      "Indlæggelser" = "hosp"
    ))
    
    # set region to nation for level 1
    if(level == 1) x.cases$region <- ""
    
    # cases
    x.cases <- x.cases %>%
      group_by(region, date) %>%
      summarise(
        deaths = sum(deaths),
        confirmed = sum(confirmed),
        hosp = sum(hosp)
      ) %>%
      group_by(region) %>%
      arrange(date) %>%
      mutate(
        deaths = cumsum(deaths),
        confirmed = cumsum(confirmed)
      )
    
    # read tests
    file <- "Regionalt_DB/16_pcr_og_antigen_test_pr_region.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.tests <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    # format tests
    x.tests <- map_data(x.tests, c(
      "Uge" = "epiweek",
      "Region" = "region",
      "Metode" = "type",
      "Prøver" = "tests"
    ))
    
    # set region to nation for level 1
    if(level == 1) x.tests$region <- ""
    
    # tests
    x.tests <- x.tests %>%
      # drop missing region and keep only PCR tests
      # only PCR tests are counted as confirmed cases
      # see https://covid19.ssi.dk/overvagningsdata/konfirmatorisk-pcr-test
      filter(type == "PCR") %>%
      # convert epiweek to date
      mutate(
        YEAR = as.integer(substr(epiweek, 0, 4)),
        WEEK = as.integer(substr(epiweek, 7, 9)),
        date = as.character(MMWRweek::MMWRweek2Date(YEAR, WEEK)+7)) %>%
      # for each date and region
      group_by(date, region) %>%
      # compute total counts
      summarize(tests = sum(tests)) %>%
      # group by region
      group_by(region) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(tests = cumsum(tests))
    
    # read people vaccinated
    file <- "Vaccine_DB/Vaccine_dato_region.csv"
    file <- unzip(zip.vacc, files = file, exdir = dir)
    x.vacc <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    # format vaccinations
    x.vacc <- map_data(x.vacc, c(
      "Dato" = "date",
      "Region" = "region",
      "Antal.1..stik" = "dose1",
      "Antal.2..stik" = "dose2",
      "Antal.3..stik" = "dose3",
      "Antal.4..stik" = "dose4"
    ))
    
    # set region to nation for level 1
    if(level == 1) x.vacc$region <- ""
    
    # vaccinations
    x.vacc <- x.vacc %>%
      group_by(region, date) %>%
      summarize(
        vaccines = sum(dose1 + dose2 + dose3 + dose4),
        people_vaccinated = sum(dose1),
        people_fully_vaccinated = sum(dose2)
      ) %>%
      group_by(region) %>%
      arrange(date) %>%
      mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated)
      )
    
    # merge
    by <- c("region", "date")
    x <- x.cases %>%
      full_join(x.tests, by = by) %>%
      full_join(x.vacc, by = by)
  }
  
  if(level==3){
    # download cases
    webpage <- "https://covid19.ssi.dk/overvagningsdata/download-fil-med-overvaagningdata"
    baseurl <- "https://files.ssi.dk/covid19/overvagning/data/overvaagningsdata-covid19"
    zip.cases <- tempfile()
    url <- get_url(webpage = webpage, baseurl = baseurl)
    download.file(url, zip.cases, quiet = TRUE, mode = "wb")
    
    # read cases
    file <- "Municipality_cases_time_series.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.cases <- read.csv(file, sep = ";", fileEncoding = "UTF-8", encoding = "ANSI")
    
    # cases
    x.cases <- x.cases %>%
      rename(date = SampleDate) %>%
      pivot_longer(
        cols = -date,
        names_to = "name",
        values_to = "confirmed"
      ) %>% 
      filter(name != "NA.") %>%
      group_by(name) %>%
      arrange(date) %>%
      mutate(confirmed = cumsum(confirmed))
    
    # read tests
    file <- "Municipality_tested_persons_time_series.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.tests <- read.csv(file, sep = ";", fileEncoding = "UTF-8", encoding = "ANSI")

    # format tests
    x.tests <- x.tests %>%
      rename(date = PrDate_adjusted) %>%
      pivot_longer(
        cols = -date,
        names_to = "name",
        values_to = "tests"
      ) %>% 
      filter(name != "NA.") %>%
      group_by(name) %>%
      arrange(date) %>%
      mutate(tests = cumsum(tests))
    
    # read people vaccinated
    file <- "Vaccine_DB/Vaccine_dato_kommune.csv"
    file <- unzip(zip.vacc, files = file, exdir = dir)
    x.vacc <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    # format people vaccinated
    x.vacc <- map_data(x.vacc, c(
      "Dato" = "date",
      "Kommune" = "name",
      "Kommunekode" = "code", 
      "Samlet.antal.1..stik" = "dose1",
      "Samlet.antal.2..stik" = "dose2",
      "Samlet.antal.3..stik" = "dose3",
      "Samlet.antal.4..stik" = "dose4"
    ))
  
    x.vacc <- x.vacc %>%
      mutate(
        vaccines = dose1 + dose2 + dose3 + dose4,
        people_vaccinated = dose1,
        people_fully_vaccinated = dose2
      )
    
    # standardize municipality names across datasets  
    name_map <- c(
      "Aarhus" = "Århus",
      "Copenhagen" = "København", 
      "Høje.Taastrup" = "Høje Tåstrup",
      "Vesthimmerlands" = "Vesthimmerland",
      "Faaborg.Midtfyn" = "Faaborg-Midtfyn",
      "Ikast.Brande" = "Ikast-Brande",
      "Lyngby.Taarbæk" = "Lyngby-Taarbæk",
      "Nordfyns" = "Nordfyn",
      "Ringkøbing.Skjern" = "Ringkøbing-Skjern"
    )
    x.cases$name <- map_values(x.cases$name, name_map)
    x.tests$name <- map_values(x.tests$name, name_map)
    x.vacc$name <- map_values(x.vacc$name, name_map)
    
    # map names to codes for all datasets
    code_map <- x.vacc$code
    names(code_map) <- x.vacc$name
    code_map["Christiansø"] <- 411 
    code_map <- code_map[!duplicated(code_map)]
    x.cases$code <- map_values(x.cases$name, code_map)
    x.tests$code <- map_values(x.tests$name, code_map)
    x.vacc$code <- map_values(x.vacc$name, code_map)
    
    # merge on codes
    by <- c("code", "date")
    x <- x.cases %>%
      full_join(x.tests, by = by) %>%
      full_join(x.vacc, by = by) 
    
  }
  
  # convert date
  x$date <- as.Date(x$date)
  
  return(x)
}
