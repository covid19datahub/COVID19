jhucsse_git <- function(cache, file, level = 1, country = NULL){

  # cache
  cachekey <- make.names(sprintf("jhuCSSE_%s_%s", file, level))
  if(cache & exists(cachekey, envir = cachedata)){

    x <- get(cachekey, envir = cachedata)

    if(!is.null(country))
      x <- x[which(x$country==country),]

    return(x)

  }

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
    xx  <- read.csv(url, cache = cache)

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
      x <- merge(x, xx, all = TRUE, by = c('id','date'))

  }
  
  # cache
  if(cache)
    assign(cachekey, x, envir = cachedata)

  # filter
  if(!is.null(country))
    x <- x[which(x$country==country),]

  # return
  return(x)

}
