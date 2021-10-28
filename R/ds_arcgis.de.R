#' Robert Koch Institute
#'
#' Data source for: Germany
#'
#' @param level 1, 2, 3
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
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#'
#' @source https://www.arcgis.com/home/item.html?id=f10774f1c63e40168479a1feb6c7ca74
#'
#' @keywords internal
#'
arcgis.de <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  # download
  url <- "https://www.arcgis.com/sharing/rest/content/items/f10774f1c63e40168479a1feb6c7ca74/data"
  x <- data.table::fread(url)
  
  # format
  x <- map_data(x, c(
    'Meldedatum'      = 'date',
    'Bundesland'      = 'state',
    'Landkreis'       = 'district',
    'IdBundesland'    = 'id_state',
    'IdLandkreis'     = 'id_district',
    'AnzahlFall'      = 'confirmed',
    'AnzahlTodesfall' = 'deaths',
    'AnzahlGenesen'   = 'recovered',
    'NeuerFall'       = 'confirmed_status',
    'NeuerTodesfall'  = 'deaths_status',
    'NeuGenesen'      = 'recovered_status'
  ))
  
  # convert date type
  x <- x[!is.na(x$date),]
  x$date <- as.Date(x$date, format = "%Y/%m/%d")
  
  # group key
  if(level == 1) 
    by <- NULL
  if(level == 2) 
    by <- c('id_state')
  if(level == 3) 
    by <- c('id_state','id_district')
  
  # The German data is slightly odd. It is a CSV file which is updated daily,
  # the 'status' flags is the status of the entry on the day the file was
  # updated. The flags mean:
  #                                     
  #    1 - cdr was only added today (as in the day the file was created)
  #    0 - cdr was added to yesterdays file, or before, but NOT today
  #   -1 - cd will be removed tomorrow but is still present today, exclude it
  #   -9 - not applicable (e.g. recovered_status=-9 on a death)
  #
  # So, basically just exclude anything with a negative value, but only for that
  # specific column type.
  # 
  # (Abbreviated case/death/recovery as cdr)
  x <- x %>%
    # drop negative counts
    mutate(
      confirmed = replace(confirmed, confirmed < 0, 0),
      deaths    = replace(deaths, deaths < 0, 0),
      recovered = replace(recovered, recovered < 0, 0)) %>%
    # group by date and admin area
    group_by_at(c('date', by)) %>%
    # compute total counts
    summarise(
      confirmed = sum(confirmed),
      deaths    = sum(deaths),
      recovered = sum(recovered)) %>%
    # group by admin area
    group_by_at(by) %>%
    # sort by date
    arrange(date) %>%
    # cumulate
    mutate(
      confirmed = cumsum(confirmed),
      deaths    = cumsum(deaths),
      recovered = cumsum(recovered))
  
  return(x) 
}
