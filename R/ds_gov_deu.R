gov_de <- function(cache,level){

  url <- "https://opendata.arcgis.com/datasets/dd4580c810204019a7b8eb3e0b329dd6_0.csv"
  
  # download
  x <- read.csv(url) #, cache = cache)
  
  # convert date type
  x$Meldedatum <- as.Date(x$Meldedatum)
  
  # group key
  if(level == 1) 
    by <- NULL
  if(level == 2) 
    by <- 'state'
  if(level == 3) 
    by <- c('state','district')
  
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

  # 'NeuerFall' = 'confirmed_status'
  confirmed <- dplyr::filter(x, !(AnzahlFall==0 & NeuerFall<0)) %>%
    map_data(c(
      'Meldedatum' = 'date',
      'AnzahlFall' = 'confirmed',
      'Bundesland' = 'state',
      'Landkreis' = 'district'
    )) %>%
    dplyr::group_by_at(c('date', by)) %>%
    dplyr::summarise(confirmed=sum(confirmed))
  
  # 'NeuerTodesfall' = 'death_status',
  deaths <- dplyr::filter(x, !(AnzahlTodesfall==0 & NeuerTodesfall<0)) %>%
    map_data(c(
      'Meldedatum' = 'date',
      'AnzahlTodesfall' = 'deaths',
      'Bundesland' = 'state',
      'Landkreis' = 'district'
    )) %>%
    dplyr::group_by_at(c('date', by)) %>%
    dplyr::summarise(deaths=sum(deaths))
  
  # 'NeuGenesen' = 'recovered_status',
  recovered <- dplyr::filter(x, !(AnzahlGenesen==0 & NeuGenesen<=0)) %>%
    map_data(c(
      'Meldedatum' = 'date',
      'AnzahlGenesen' = 'recovered',
      'Bundesland' = 'state',
      'Landkreis' = 'district'
    )) %>%
    dplyr::group_by_at(c('date', by)) %>%
    dplyr::summarise(recovered=sum(recovered))

  # merge
  x <- merge(confirmed, deaths, by=c('date', by), all=TRUE)
  x <- merge(x, recovered,  by=c('date', by), all=TRUE)
  
  x <- x %>%
    dplyr::group_by_at(by) %>%
    dplyr::arrange(date) %>%
    replace(is.na(.), 0) %>%
    dplyr::mutate(
      confirmed = cumsum(confirmed),
      deaths    = cumsum(deaths),
      recovered = cumsum(recovered)
    )
  
  # return
  return(x) 

}
