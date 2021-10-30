#' Croatian Institute of Public Health
#'
#' Data source for: Croatia
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#'
#' @source https://www.koronavirus.hr/otvoreni-strojno-citljivi-podaci/526
#'
#' @keywords internal
#'
koronavirus.hr <- function(level) {
  if(!level %in% 1:2) return(NULL)
  
  # download
  url <- 'https://www.koronavirus.hr/json/?action=po_danima_zupanijama'
  x   <- jsonlite::fromJSON(url, flatten=TRUE)
  
  # make longer along regions (zupanija)
  x <- bind_rows(apply(x, 1, function(row) {
    cbind(date = row$Datum, row$PodaciDetaljno)
  }))

  # format
  x <- map_data(x, c(
    "date"           = "date",
    "broj_zarazenih" = "confirmed",
    "broj_umrlih"    = "deaths",
    "broj_aktivni"   = "active",
    "Zupanija"       = "region"
  ))
  
  # recovered
  x <- x %>%
    mutate(recovered = confirmed - deaths - active)
  
  if(level==1){

    # compute total counts    
    x <- x %>%
      group_by(date) %>%
      summarise(across(c("confirmed", "deaths", "recovered"), sum))
    
  }
  
  if(level==2){

    # sanitize regions
    x$region <- trimws(x$region)
    
  }
  
  # date
  x$date <- as.Date(x$date, "%Y-%m-%d %H:%M")
  
  return(x)
}
