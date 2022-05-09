#' Wesley Cota
#'
#' Data source for: Brazil
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#'
#' @source https://github.com/wcota/covid19br
#'
#' @keywords internal
#' 
github.wcota.covid19br <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  if(level==1 | level==2){
    
    # download
    url <- "https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv"
    x <- read.csv(url)
    
    # formatting
    x <- map_data(x, c(
      "date" = "date",
      "state" = "state",
      "deaths" = "deaths",
      "totalCases" = "confirmed",
      "recovered" = "recovered",
      "tests" = "tests",
      "vaccinated" = "first",
      "vaccinated_second" = "second",
      "vaccinated_single" = "oneshot",
      "vaccinated_third" = "extra"
    ))
    
    # total number of doses
    x <- x %>%
      dplyr::mutate(
        vaccines = first + replace_na(second, 0) + replace_na(oneshot, 0) + replace_na(extra, 0),
        people_vaccinated = first + replace_na(oneshot, 0),
        people_fully_vaccinated = second + replace_na(oneshot, 0))

    # filter
    idx <- which(x$state=="TOTAL")
    if(level==1)
      x <- x[idx,]
    if(level==2)
      x <- x[-idx,]
    
  }
  else {

    # urls
    urls <- sprintf(
      "https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-cities-time%s.csv.gz",
      c('', paste0('_', 2020:2030))
    )
    
    # filter by urls that actually exist
    urls <- urls[!sapply(urls, httr::http_error)]
    
    # process data by year
    x <- lapply(urls, function(url){

      # download  
      tmp <- tempfile()
      download.file(url, destfile=tmp, mode="wb", quiet = TRUE)
      x <- read.csv(tmp)
      unlink(tmp)
      
      # formatting
      x <- map_data(x, c(
        "date" = "date",
        "ibgeID" = "code",
        "state" = "state",
        "deaths" = "deaths",
        "totalCases" = "confirmed"
      ))
      
      # filter cities
      x <- x[nchar(x$code)==7,]
      
    })
    
    # merge all years together
    x <- do.call(rbind, x)
    
  }
  
  # date
  x$date <- as.Date(x$date)
  
  return(x)
}
