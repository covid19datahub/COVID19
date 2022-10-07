#' Wesley Cota
#'
#' Data source for: Brazil
#'
#' @param level 3
#'
#' @section Level 3:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://github.com/wcota/covid19br-vac
#'
#' @keywords internal
#' 
github.wcota.covid19br.vac <- function(level){
  if(level != 3) return(NULL)
  
  # master file
  url <- "https://raw.githubusercontent.com/wcota/covid19br-vac/main/states.json"
  master <- jsonlite::fromJSON(url)
  
  # urls
  urls <- sprintf(
    "https://github.com/wcota/covid19br-vac/blob/main/processed_%s.csv.gz?raw=true",
    names(master$vaccination)
  )
  
  # process data by state
  x <- lapply(urls, function(url){
    
    # read  
    tmp <- tempfile()
    download.file(url, destfile=tmp, mode="wb", quiet = TRUE)
    x <- read.csv(tmp)
    unlink(tmp)
    
    # formatting
    x <- map_data(x, c(
      "date" = "date",
      "ibgeID" = "code",
      "dose" = "dose",
      "count" = "n"
    ))
    
    # filter cities
    x <- x[nchar(x$code)==7,]
  
  })
  
  # merge all states together
  x <- do.call(rbind, x)
  
  # compute vaccinated people by municipality and date
  x <- x %>%
    dplyr::group_by(code, date) %>%
    dplyr::summarise(
      vaccines = sum(n),
      people_vaccinated = sum(n[dose == 0 | dose == 1]),
      people_fully_vaccinated = sum(n[dose == 0 | dose == 2]))

  # convert to date and drop missing
  x$date <- as.Date(x$date)
  x <- x[!is.na(x$date),]
  
  # compute cumulative counts
  x <- x %>%
    dplyr::group_by(code) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(vaccines = cumsum(vaccines),
                  people_vaccinated = cumsum(people_vaccinated),
                  people_fully_vaccinated = cumsum(people_fully_vaccinated))
  
  return(x)
}
