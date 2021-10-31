#' Johns Hopkins Center for Systems Science and Engineering
#'
#' Data source for: Worldwide
#'
#' @param level 1, 2, or 3 (U.S only)
#' @param file one of "global" for worldwide data or "US" for U.S. data
#' @param country filter by name of country
#' @param state filter by name of state
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
#' - confirmed cases (U.S. only)
#' - deaths (U.S. only)
#'
#' @source https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series
#'
#' @keywords internal
#' 
github.cssegisanddata.covid19 <- function(level = 1, file = "global", country = NULL, state = NULL){
  if(file=="US" & !level %in% 1:3) return(NULL)
  if(file=="global" & !level %in% 1:2) return(NULL)
  
  # source
  repo <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"

  if(file=="global")
    urls = c(
      "confirmed" = "time_series_covid19_confirmed_global.csv",
      "deaths"    = "time_series_covid19_deaths_global.csv",
      "recovered" = "time_series_covid19_recovered_global.csv"
    )

  if(file=="US")
    urls = c(
      "confirmed" = "time_series_covid19_confirmed_US.csv",
      "deaths"    = "time_series_covid19_deaths_US.csv"
    )

  for(i in 1:length(urls)){

    # download
    url <- sprintf("%s/csse_covid_19_time_series/%s", repo, urls[i])
    xx  <- read.csv(url, cache = level!=3)

    if(class(xx)=="try-error")
      next

    # NA
    xx <- dplyr::na_if(xx,  0)
    xx <- dplyr::na_if(xx, -1)
    
    # formatting
    colnames(xx) <- gsub(pattern = "\\_$", replacement = "", x = colnames(xx))
    colnames(xx) <- gsub(pattern = "\\_", replacement = ".", x = colnames(xx))
    colnames(xx) <- gsub(pattern = "^.\\_\\_", replacement = "", x = colnames(xx))
    colnames(xx) <- gsub(pattern = "^_", replacement = "", x = colnames(xx))

    if(file=="US") {
      
      colnames(xx) <- map_values(colnames(xx), c(
        'UID'            = 'id',
        'FIPS'           = 'fips',
        'iso3'           = 'country',
        'Province.State' = 'state',
        'Admin2'         = 'city',
        'Lat'            = 'lat',
        'Long'           = 'lng',
        'Population'     = 'pop'))
      
      xx <- xx[which( (!is.na(xx$city) & !is.na(xx$fips) & !is.na(xx$id)) | xx$country!="USA" ),]
      if(level==3){
        xx <- xx[-which(xx$city=="Unassigned"),]
        xx <- xx[!grepl("^Out of ", xx$city),]
      }
        
    }
    if(file=="global"){
      
      colnames(xx) <- map_values(colnames(xx), c(
        'Country.Region' = 'country',
        'Province.State' = 'state',
        'Lat'            = 'lat',
        'Long'           = 'lng'))

      idx <- which(xx$state=="Grand Princess")
      xx$country[idx] <- "Grand Princess"
      xx$state[idx]   <- NA
      
      idx <- which(xx$state %in% c("Recovered","Diamond Princess"))
      if(length(idx))
        xx  <- xx[-idx,]
      
      idx <- which(xx$country %in% c("Summer Olympics 2020"))
      if(length(idx))
        xx  <- xx[-idx,]
      
      if(level==1){
        xx <- xx[is.na(xx$state),]
        xx$id <- xx$country
      }
      if(level==2){
        xx <- xx[!is.na(xx$state),]
        xx$id <- paste(xx$country, xx$state, sep = ", ")
      }
        
    }

    # pivot
    by <- c('id','country','state','city','lat','lng','fips','pop')
    cn <- colnames(xx)
    by <- by[by %in% cn]
    cn <- (cn %in% by) | !is.na(as.Date(cn, format = "X%m.%d.%y"))
    xx <- xx[,cn] %>% tidyr::pivot_longer(cols = -by, values_to = names(urls[i]), names_to = "date")
    
    # date
    xx$date <- as.Date(xx$date, format = "X%m.%d.%y")

    # merge
    if(i==1)
      x <- xx
    else
      x <- merge(x, xx, all = TRUE, fill = TRUE, by = c('id','date'))

  }
  
  # filter
  if(!is.null(country))
    x <- x[which(x$country==country),]
  if(!is.null(state))
    x <- x[which(x$state==state),]

  # remove constant cumulative counts
  cols <- intersect(colnames(x), c("confirmed", "deaths", "recovered"))
  clean <- function(x) replace(x, c(NA, diff(x))==0, NA)
  x <- x %>% 
    group_by(id) %>%
    arrange(date) %>%
    mutate(across(cols, clean))
  
  return(x)
}
