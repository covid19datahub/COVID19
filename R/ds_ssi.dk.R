#' Statens Serum Institut
#'
#' Data source for: Denmark
#'
#' @param level 2, 3
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
  if(!level %in% 2:3) return(NULL)

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
  
    if(level==2) {
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
      "Bekræftede.tilfælde.i.alt" = "confirmed"
    ))
    
    # cases
    x.cases <- x.cases %>%
      # for each region and date
      group_by(region, date) %>%
      # compute total counts
      summarise(
        deaths = sum(deaths),
        confirmed = sum(confirmed)) %>%
      # group by region
      group_by(region) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        deaths = cumsum(deaths),
        confirmed = cumsum(confirmed))
    
    # read hosp
    file <- "Regionalt_DB/27_indl_kategori_dag_region.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.hosp <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    # format hosp
    x.hosp <- map_data(x.hosp, c(
      "Region" = "region",
      "Dato" = "date",
      "Kategori" = "type",
      "Antal.borgere" = "hosp"
    ))
    
    x.hosp <- x.hosp %>% 
      filter(!is.na(region)) %>% 
      filter(type != "Indlæggelse pga. andre forhold end covid-19") %>%  
      group_by(date, region) %>%
      summarize(hosp = sum(hosp))
    
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
  
    # tests
    x.tests <- x.tests %>%
      # drop missing region and keep only PCR tests
      # only PCR tests are counted as confirmed cases
      # see https://covid19.ssi.dk/overvagningsdata/konfirmatorisk-pcr-test
      filter(!is.na(region) & type=="PCR") %>%
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
    
    # format people vaccinated
    x.vacc <- map_data(x.vacc, c(
      "Dato" = "date",
      "Region" = "region",
      "Samlet.antal.1..stik" = "people_vaccinated",
      "Samlet.antal.2..stik" = "people_fully_vaccinated"
    ))
    
    # merge
    by <- c("region", "date")
    x <- x.cases %>%
      full_join(x.hosp, by = by) %>%
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
    
    # format cases
    x.cases <- x.cases %>%
      rename(date = SampleDate) %>%
      pivot_longer(
        cols = -date,
        names_to = "name",
        values_to = "confirmed"
      ) %>% 
      filter(name != "NA.")
    
    # cases
    x.cases <- x.cases %>%
      group_by(name, date) %>%
      summarize(confirmed = sum(confirmed)) %>% 
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
      filter(name != "NA.")
    
    x.tests <- x.tests %>%
      group_by(date, name) %>%
      # compute total counts
      summarize(tests = sum(tests)) %>%
      # group by municipality
      group_by(name) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
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
      "Samlet.antal.1..stik" = "people_vaccinated",
      "Samlet.antal.2..stik" = "people_fully_vaccinated"
    ))
  
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
    
    x.cases$name <- ifelse(x.cases$name %in% names(name_map), name_map[x.cases$name], x.cases$name)
    x.tests$name <- ifelse(x.tests$name %in% names(name_map), name_map[x.tests$name], x.tests$name)
    x.vacc$name <- ifelse(x.vacc$name %in% names(name_map), name_map[x.vacc$name], x.vacc$name)
    
    x <- full_join(x.cases, x.tests, by = c("date", "name"))
    
    # map codes from x.vacc
    idx <- which(!duplicated(x.vacc$code)) 
    map <- setNames(x.vacc$code[idx], x.vacc$name[idx])

    x.tests$code <- ifelse(x.tests$name == "Christiansø", 411, 
                           as.integer(map[x.tests$name]))
    x.cases$code <- ifelse(x.cases$name == "Christiansø", 411, 
                           as.integer(map[x.tests$name]))
    
    # merge
    by <- c("code", "date")
    x <- x.cases %>%
      full_join(x.tests, by = by) %>%
      full_join(x.vacc, by = by) 
    
  }
  
  # convert date
  x$date <- as.Date(x$date)
  
  return(x)
}
