covid19 <- function(x, raw = FALSE){

  # bindings
  id <- date <- country <- state <- city <- lat <- lng <- confirmed <- tests <- deaths <- NULL

  # create columns if missing
  col <- c('id','date','country','state','city','lat','lng','deaths','confirmed','tests','deaths_new','confirmed_new','tests_new','pop','pop_14','pop_15_64','pop_65','pop_age','pop_density','pop_death_rate')
  x[,col[!(col %in% colnames(x))]] <- NA
  x$id <- paste(x$country, x$state, x$city, sep = "|")

  # subset
  x <- x[,col]

  # fill dates
  x <- fill(x)

  # clean
  x <- x %>%
    dplyr::arrange(date) %>%
    dplyr::group_by(id)  %>%
    tidyr::fill(.direction = "downup",
                'country', 'state', 'city',
                'lat', 'lng',
                'pop','pop_14','pop_15_64','pop_65',
                'pop_age','pop_density',
                'pop_death_rate')

  if(!raw)
    x <- x %>%
    tidyr::fill(.direction = "down",
                'confirmed', 'tests', 'deaths') %>%
    tidyr::replace_na(list(confirmed = 0,
                           tests     = 0,
                           deaths    = 0))

  x <- x %>%
    dplyr::mutate(confirmed_new = c(confirmed[1], pmax(0,diff(confirmed))),
                  tests_new     = c(tests[1],     pmax(0,diff(tests))),
                  deaths_new    = c(deaths[1],    pmax(0,diff(deaths))))

  # convert
  x$date <- as.Date(x$date)
  for(i in c('id','country','state','city'))
    x[[i]] <- as.character(x[[i]])

  # return
  return(x)

}
