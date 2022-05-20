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
ssi.dk <- function(level){
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
  
  # download cases
  webpage <- "https://covid19.ssi.dk/overvagningsdata/download-fil-med-overvaagningdata"
  baseurl <- "https://files.ssi.dk/covid19/overvagning/dashboard/overvaagningsdata-dashboard-covid19"
  zip.cases <- tempfile()
  url <- get_url(webpage = webpage, baseurl = baseurl)
  download.file(url, zip.cases, quiet = TRUE, mode = "wb")  

  # download vaccines  
  webpage <- "https://covid19.ssi.dk/overvagningsdata/download-fil-med-vaccinationsdata"
  baseurl <- "https://files.ssi.dk/covid19/vaccinationsdata/zipfil/vaccinationsdata-dashboard-covid19"
  zip.vacc <- tempfile()
  url <- get_url(webpage = webpage, baseurl = baseurl)
  download.file(url, zip.vacc, quiet = TRUE, mode = "wb")  
  
  # temp dir to unzip
  dir <- tempdir()
  
  if(level==2){
    
    # read cases and deaths
    file <- "Regionalt_DB/03_bekraeftede_tilfaelde_doede_indlagte_pr_dag_pr_koen.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.cases <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")

    # format cases
    x.cases <- map_data(x.cases, c(
      "Region" = "region",
      "Prøvetagningsdato" = "date",
      "Døde" = "deaths",
      "Bekræftede.tilfælde" = "confirmed",
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
    file <- "Regionalt_DB/15_indlagte_pr_region_pr_dag.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.hosp <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    # format hosp
    x.hosp <- map_data(x.hosp, c(
      "Region" = "region",
      "Dato" = "date",
      "Indlagte" = "hosp"
    ))
    # drop duplicated entry: Syddanmark 2021-10-26
    x.hosp <- x.hosp[!duplicated(x.hosp),]
     
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
    
    # read cases
    file <- "Kommunalt_DB/07_bekraeftede_tilfaelde_pr_dag_pr_kommune.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.cases <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    # format cases
    x.cases <- map_data(x.cases, c(
      "Kommune" = "code",
      "Kommunenavn" = "name",
      "Dato" = "date",
      "Bekræftede.tilfælde" = "confirmed",
      "Bekræftede.tilfælde.i.alt" = "confirmed"
    )) 
    
    # cases
    x.cases <- x.cases %>%
      filter(!is.na(code)) %>%
      group_by(code) %>%
      arrange(date) %>%
      mutate(confirmed = cumsum(confirmed))
    
    # read tests
    file <- "Kommunalt_DB/12_pcr_og_antigen_test_pr_kommune.csv"
    file <- unzip(zip.cases, files = file, exdir = dir)
    x.tests <- read.csv(file, sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    # format tests
    x.tests <- map_data(x.tests, c(
      "Uge" = "epiweek",
      "Kommune.kode" = "code",
      "Kommunenavn" = "name",
      "Metode" = "type",
      "Prøver" = "tests"
    ))
    
    # map
    idx <- which(!duplicated(x.tests$code))
    map <- x.tests$code[idx]
    names(map) <- x.tests$name[idx]
    
    # tests
    x.tests <- x.tests %>%
      # drop missing municipality and keep only PCR tests
      # only PCR tests are counted as confirmed cases
      # see https://covid19.ssi.dk/overvagningsdata/konfirmatorisk-pcr-test
      filter(!is.na(code) & !is.na(name) & type=="PCR") %>%
      # convert epiweek to date
      mutate(
        YEAR = as.integer(substr(epiweek, 0, 4)),
        WEEK = as.integer(substr(epiweek, 7, 9)),
        date = as.character(MMWRweek::MMWRweek2Date(YEAR, WEEK)+7)) %>%
      # for each date and municipality
      group_by(date, code) %>%
      # compute total counts
      summarize(tests = sum(tests)) %>%
      # group by municipality
      group_by(code) %>%
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
      "Samlet.antal.1..stik" = "people_vaccinated",
      "Samlet.antal.2..stik" = "people_fully_vaccinated"
    ))
    x.vacc$code <- as.integer(map_values(x.vacc$name, map = map))
    
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
