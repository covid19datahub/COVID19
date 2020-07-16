gov_de <- function(cache, level){

  url <- "https://opendata.arcgis.com/datasets/dd4580c810204019a7b8eb3e0b329dd6_0.csv"
  
  # download
  x <- read.csv(url, cache = cache)
  
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
    
    dplyr::mutate(
      confirmed = replace(confirmed, confirmed < 0, 0),
      deaths    = replace(deaths, deaths < 0, 0),
      recovered = replace(recovered, recovered < 0, 0)
    ) %>%
    
    dplyr::group_by_at(c('date', by)) %>%
  
    dplyr::summarise(
      confirmed = sum(confirmed),
      deaths    = sum(deaths),
      recovered = sum(recovered),
      .groups   = 'keep'
    ) %>%
    
    dplyr::group_by_at(by) %>%
    
    dplyr::arrange(date) %>%
    
    dplyr::mutate(
      confirmed = cumsum(confirmed, na.rm = TRUE),
      deaths    = cumsum(deaths, na.rm = TRUE),
      recovered = cumsum(recovered, na.rm = TRUE)
    )
  
  # return
  return(x) 

}
