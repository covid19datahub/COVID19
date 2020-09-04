gov_hr <- function(level, cache) {
  
  # download
  url <- 'https://www.koronavirus.hr/json/?action=po_danima_zupanijama'
  x   <- jsonlite::fromJSON(url, flatten=T)
  
  # make longer along regions (zupanija)
  rows <- apply(x, 1, function(row) {
    dt <- row$Datum
    df <- row$PodaciDetaljno
    nuts <- c(
      "HR047","HR04A","HR037","HR041","HR036","HR04D","HR045",
      "HR043","HR032","HR046","HR04B","HR049","HR031","HR034",
      "HR04E","HR035","HR044","HR048","HR04C","HR033","HR042")
    cbind(date = dt, df, nuts = nuts)
  })
  x <- do.call("rbind", rows)
  
  # format
  colnames(x) <- c("date","confirmed","deaths","active","region","nuts")
  x$date <- as.Date(x$date, "%Y-%m-%d %H:%M")
  x <- x %>%
    dplyr::mutate(region = stringr::str_replace_all(region, stringr::regex("[^[:alnum:]- ]+"), "")) %>%
    dplyr::mutate(dplyr::across(where(is.character), stringr::str_trim))
  #rownames(x) <- 1:nrow(x)
  
  # level 2
  if(level == 1) {
    x <- x %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(
        confirmed = sum(confirmed),
        deaths    = sum(deaths),
        active    = sum(active),
        .groups="drop")
  }
  
  return(x)
}


