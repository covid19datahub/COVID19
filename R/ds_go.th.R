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
  
  # link to waves 1-2 ad 3
  if(level == 1){
    w1 <- "https://covid19.ddc.moph.go.th/api/Cases/round-1to2-all"
    w2 <- "https://covid19.ddc.moph.go.th/api/Cases/timeline-cases-all" 
  }
  if(level == 2){
    w1 <- "https://covid19.ddc.moph.go.th/api/Cases/round-1to2-by-provinces"
    w2 <- "https://covid19.ddc.moph.go.th/api/Cases/timeline-cases-by-provinces"
  }
  
  # download waves
  x1 <- jsonlite::fromJSON(w1, flatten=TRUE)
  x2 <- jsonlite::fromJSON(w2, flatten=TRUE)
  
  # merge waves and format
  x <- dplyr::bind_rows(x1, x2) %>%
    map_data(c(
      "txn_date" = "date",
      "province" = "province",
      "total_case" = "confirmed",
      "total_death" = "deaths"
    ))
  
  # drop unassigned
  if(level==2){
    x <- filter(x, province!="ไม่ระบุ")
  }
  
  # convert date
  x$date <- as.Date(x$date)
  
  # fix duplicates
  cols <- intersect(colnames(x), c("date","province"))
  x <- x[!duplicated(x[,cols]),]
  
  return(x)
}
