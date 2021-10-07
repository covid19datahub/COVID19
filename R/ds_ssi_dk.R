ssi_dk <- function(level){
  
  webpage <- "https://covid19.ssi.dk/overvagningsdata/download-fil-med-overvaagningdata"
  baseurl <- "https://files.ssi.dk/covid19/overvagning/dashboard/overvaagningsdata-dashboard-covid19"
  
  get_url <- function(webpage, baseurl){
    html <- httr::GET(webpage)
    data <- httr::content(html)
    data <- as.character(data)
    url <- paste0(baseurl, "-", format(Sys.Date()-2, "%d%m%Y"))
    pattern <- paste0(url, "[-a-z0-9]*")
    m <- regexpr(pattern, data, ignore.case = TRUE)
    regmatches(data, m)
  }
  
  url <- get_url(webpage = webpage, baseurl = baseurl)
  
  zip <- tempfile()
  download.file(url, zip, quiet = TRUE, mode = "wb")  
  
  if(level == 2){
    
    dir <- tempdir()
    files <- "Regionalt_DB/03_bekraeftede_tilfaelde_doede_indlagte_pr_dag_pr_koen.csv"
    files <- unzip(zip, files = files, exdir = dir)
    
    x <- read.csv(files[1], sep = ";", fileEncoding = "Latin1", encoding = "ANSI")
    
    x <- map_data(x, c(
      "Region" = "region",
      "Prøvetagningsdato" = "date",
      "Døde" = "deaths",
      "Bekræftede.tilfælde" = "confirmed"
    )) 
    
    x <- x %>%
      dplyr::group_by(region, date) %>%
      dplyr::summarise(
        deaths = sum(deaths),
        confirmed = sum(confirmed)) %>%
      dplyr::group_by(region) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(
        deaths = cumsum(deaths),
        confirmed = cumsum(confirmed))
    
    
  }
  
  x$date <- as.Date(x$date)
  
  return(x)
  
}
