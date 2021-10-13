go_th <- function(level){
  
  # see https://data.go.th/en/dataset/covid-19-daily
  
  # link to waves 1-2 ad 3
  if(level == 1){
    w1 <- "https://covid19.ddc.moph.go.th/api/Cases/round-1to2-all"
    w2 <- "https://covid19.ddc.moph.go.th/api/Cases/timeline-cases-all" 
  }
  if(level == 2){
    w1 <- "https://covid19.ddc.moph.go.th/api/Cases/round-1to2-by-provinces"
    w2 <- "https://covid19.ddc.moph.go.th/api/Cases/timeline-cases-by-provinces"
  }
  
  # download
  x1 <- jsonlite::fromJSON(w1, flatten=TRUE)
  x2 <- jsonlite::fromJSON(w2, flatten=TRUE)
  
  # merge and format
  x <- dplyr::bind_rows(x1, x2) %>%
    map_data(c(
      "txn_date" = "date",
      "province" = "province",
      "total_case" = "confirmed",
      "total_death" = "deaths"
    ))
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
  
}
