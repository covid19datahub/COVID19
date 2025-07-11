#' Department of Disease Control, Thailand Ministry of Public Health
#'
#' Data source for: Thailand
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#'
#' @source https://data.go.th/en/dataset/covid-19-daily
#'
#' @keywords internal
#'
go.th <- function(level){
  if(!level %in% 1:2) return(NULL)  
  
  # download waves
  if(level == 1){
    x1 <- jsonlite::fromJSON("https://covid19.ddc.moph.go.th/api/Cases/round-1to2-all", flatten=TRUE)
    x2 <- jsonlite::fromJSON("https://covid19.ddc.moph.go.th/api/Cases/timeline-cases-all", flatten=TRUE)
  }
  
  if(level == 2){
    x1 <- jsonlite::fromJSON("https://covid19.ddc.moph.go.th/api/Cases/round-1to2-by-provinces", flatten=TRUE)
    x2 <- jsonlite::fromJSON("https://covid19.ddc.moph.go.th/api/Cases/timeline-cases-by-provinces", flatten=TRUE)
   
    # extract data from list
    if (is.list(x1)) x1 <- x1$data
  }

  # merge waves and format
  x <- dplyr::bind_rows(x1, x2) %>%
    map_data(c(
      "year",
      "weeknum",
      "update_date",
      "province" = "province",
      "total_case" = "confirmed",
      "total_death" = "deaths"
    )) 
  
  # create date 
  x$date <- ISOweek::ISOweek2date(paste0(x$year, "-W", sprintf("%02d", x$weeknum), "-7"))
  
  # filter
  x <- x %>% 
    arrange(desc(update_date))
  
  if ("province" %in% names(x)) {
    x <- x %>% distinct(province, date, .keep_all = TRUE)
  } else {
    x <- x %>% distinct(date, .keep_all = TRUE)
  }
  
  # drop unassigned and whole country data
  if(level==2) 
    x <- x[!(x$province %in% c("ทั้งประเทศ", "ไม่ระบุ")), ]
  
  return(x)
}
