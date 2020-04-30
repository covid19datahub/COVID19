jhuCSSE <- function(cache, file, level = 1, id = NULL){

  # cache
  cachekey <- make.names(sprintf("jhuCSSE_%s_%s", file, level))
  if(cache & exists(cachekey, envir = cachedata)){

    x <- get(cachekey, envir = cachedata)

    if(!is.null(id))
      x <- x[x$country==id,]

    return(x)

  }

  # source
  repo <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"

  if(file=="global")
    urls = c(
      "recovered" = "time_series_covid19_recovered_global.csv",
      "confirmed" = "time_series_covid19_confirmed_global.csv",
      "deaths"    = "time_series_covid19_deaths_global.csv"
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

    # formatting
    colnames(xx) <- gsub(pattern = "_", replacement = ".", x = colnames(xx), fixed = TRUE)
    colnames(xx) <- gsub(pattern = "^.\\_\\_", replacement = "", x = colnames(xx), fixed = FALSE)
    colnames(xx) <- gsub(pattern = "^_", replacement = "", x = colnames(xx), fixed = FALSE)
    colnames(xx) <- gsub(pattern = "_$", replacement = "", x = colnames(xx), fixed = FALSE)

    xx$country <- xx$Country.Region
    xx$state   <- xx$Province.State

    if(file=="US") {
      
      xx$country <- xx$iso3
      xx$city    <- xx$Admin2
      
      xx <- xx[(!is.na(xx$city) & !is.na(xx$FIPS) & !is.na(xx$UID)) | xx$country!="USA",]
      if(level==3)
        xx <- xx[-which(xx$city=="Unassigned"),]
      
    }
    if(file=="global"){
      
      idx <- which(xx$state=="Grand Princess")
      xx$country[idx] <- "Grand Princess"
      xx$state[idx]   <- NA
      
      idx <- which(xx$state %in% c("Recovered","Diamond Princess"))
      if(length(idx))
        xx  <- xx[-idx,]
      
      if(level==1)
        xx <- xx[is.na(xx$state),]
      if(level==2)
        xx <- xx[!is.na(xx$state),]
      
    }

    # pivot
    by <- c('country','state','city')
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
      x <- merge(x, xx, all = TRUE, by = c(by, "date"))

  }
  
  # cache
  if(cache)
    assign(cachekey, x, envir = cachedata)

  # filter
  if(!is.null(id))
    x <- x[x$country==id,]

  # return
  return(x)

}
