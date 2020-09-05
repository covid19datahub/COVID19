gov_hr <- function(level, cache) {
  
  # download
  url <- 'https://www.koronavirus.hr/json/?action=po_danima_zupanijama'
  x   <- jsonlite::fromJSON(url, flatten=TRUE)
  
  # make longer along regions (zupanija)
  rows <- apply(x, 1, function(row) {
    cbind(date = row$Datum, row$PodaciDetaljno)
  })
  x <- do.call("rbind", rows)
  
  # format
  x <- map_data(x, c(
    "date"           = "date",
    "broj_zarazenih" = "confirmed",
    "broj_umrlih"    = "deaths",
    "broj_aktivni"   = "active",
    "Zupanija"       = "region"
  ))
  
  # sanitize
  x$region <- trimws(x$region)
  
  # date
  x$date <- as.Date(x$date, "%Y-%m-%d %H:%M")
  
  # return
  return(x)
}


