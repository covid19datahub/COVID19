#' @importFrom dplyr %>%
NULL



.onAttach <- function(libname, pkgname) {

  if(interactive() & requireNamespace('COVID19', quietly = TRUE)){

    packageStartupMessage("The coronavirus situation is changing fast. Checking for updates...")

    description <- try(readLines('https://raw.githubusercontent.com/covid19datahub/COVID19/master/DESCRIPTION'), silent = TRUE)
    if(class(description)=="try-error")
      return()
      
    id <- which(startsWith(prefix = "Version:", x = description))
    v  <- as.package_version(gsub(pattern = "^Version:\\s*", replacement = "", x = description[id]))

    if(v > utils::packageVersion(pkg = "COVID19")){

      yn <- utils::askYesNo("Package COVID19: new version available. Update now?")
      if(!is.na(yn)) if(yn)
        update()

    } else {

      packageStartupMessage("...up to date.")

    }

  }

}



update <- function(){

  detach("package:COVID19", unload=TRUE)
  x <- try(remotes::install_github('covid19datahub/COVID19', quiet = FALSE, upgrade = FALSE), silent = TRUE)
  library(COVID19)

}



db <- function(id){
  suppressWarnings(
    utils::read.csv(system.file("extdata", "db", paste0(id,".csv"), package = "COVID19"), 
                    na.strings = "", 
                    stringsAsFactors = FALSE, 
                    encoding = "UTF-8", 
                    colClasses = c("id" = "character"))
  )
  
}




fix <- function(id){

  x <- try(suppressWarnings(utils::read.csv(system.file("extdata", "fix", paste0(id,".csv"), package = "COVID19"), na.strings = "", stringsAsFactors = FALSE)), silent = TRUE)
  if(class(x)=="try-error")
    return(NULL)

  return(x)

}



csv <- function(ISO = NULL, x = NULL, save = FALSE){

  cn <- vars("slow")
  cn <- cn[!(cn %in% c('iso_alpha_3','iso_alpha_2','iso_numeric','country'))]

  if(!is.null(x)){
    x[,cn[!(cn %in% colnames(x))]] <- NA
    x <- x[,cn]
    x <- x[!duplicated(x),]
  }

  if(!is.null(ISO))
    x <- dplyr::bind_rows(db(ISO), x)

  x <- x[!duplicated(x),]
  x[,cn[!(cn %in% colnames(x))]] <- NA
  x <- dplyr::arrange(x, -rowSums(is.na(x)), x$state, x$city)

  if(save & !is.null(ISO))
    utils::write.csv(x, paste0(ISO,".csv"), row.names = FALSE, na = "", fileEncoding = "UTF-8")

  return(x)

}



mapvalues <- function(x, map){

  from <- names(map)
  to   <- map

  for(i in 1:length(map)){

    idx <- which(x==from[i])
    if(length(idx)>0)
      x[idx] <- to[i]

  }

  return(x)

}



drop <- function(x){

  idx <- which(endsWith(colnames(x), '.drop'))
  if(length(idx)>0)
    x <- x[,-idx]

  return(x)

}


cachecall <- function(fun, ...){

  args  <- list(...)
  cache <- ifelse(is.null(args$cache), TRUE, args$cache)
  key   <- make.names(sprintf("%s_%s",paste(deparse(fun), collapse = ''),paste(names(args),args,sep = ".",collapse = "..")))
  
  if(cache & exists(key, envir = cachedata))
    return(get(key, envir = cachedata))
  else
    x <- try(do.call(fun, args = args), silent = TRUE)

  if("try-error" %in% class(x))
    x <- NULL

  if(cache)
    assign(key, x, envir = cachedata)

  return(x)

}


read.csv <- function(file, cache, na.strings = "", stringsAsFactors = FALSE, encoding = "UTF-8", ...){

  if(cache)
    x <- cachecall(utils::read.csv, file = file, na.strings = na.strings, stringsAsFactors = stringsAsFactors, encoding = encoding, ...)
  else
    x <- utils::read.csv(file = file, na.strings = na.strings, stringsAsFactors = stringsAsFactors, encoding = encoding, ...)

  return(x)

}

read_excel_from_url <- function(path, ...) {
  tmp <- tempfile()
  download.file(path, destfile=tmp, mode="wb")
  x <- readxl::read_excel(path=tmp, ...)
  return(x)
}

read_excel <- function(path, cache, ...) {
  # is url (readxl::read_excel supports only http, https, ftp)
  if(stringr::str_detect(path, "^(http:\\/\\/)|(https:\\/\\/)|(ftp:\\/\\/)")) 
    reader <- read_excel_from_url
  # local file
  else
    reader <- readxl::read_excel
  
  if(cache)
    x <- cachecall(reader, path=path, ...)
  else
    x <- reader(path=path, ...)
  
  return(x)

}


id <- function(..., esc = TRUE){

  args <- list(...)

  x <- NULL
  for(i in args){

    i[is.na(i)] <- ""

    if(esc)
      i <- gsub(",", "", i)

    if(is.null(x))
      x <- i
    else
      x <- gsub(", $", "", paste(x, i, sep = ', '))

  }

  return(x)

}


test <- function(ISO = NULL, level, end, raw){

  x <- covid19(ISO = ISO, level = level, end = end, raw = raw)
  y <- covid19(ISO = ISO, level = level, end = end, raw = raw, vintage = TRUE)

  id <- intersect(x$id, y$id)
  dd <- intersect(x$date, y$date)
  cn <- intersect(colnames(x), colnames(y))

  x <- x[which((x$id %in% id) & (x$date %in% dd)), cn]
  y <- y[which((y$id %in% id) & (y$date %in% dd)), cn]

  return(mean(x==y, na.rm = TRUE))

}


check <- function(x){
  
  x %>% 
    dplyr::group_by(id) %>% 
    dplyr::group_map(function(x, g){
      
      for(i in vars('fast')){
        
        plot(x[[i]]~x$date, main = paste(g[[1]], i, sep = ' - '), ylab = '', xlab = '')
        rl <- readline("Press enter: next plot \nType 's': next group \nType 'q': abort")
        
        if(rl=='s') break
        if(rl=='q') stop("aborted")
        
      }
      
    })
  
}


vars <- function(type = "all"){

  fast <- c('deaths','confirmed','tests','recovered',
            'hosp','icu','vent',
            'driving', 'walking', 'transit')

  slow <- c('country','state','city',
            'lat','lng',
            'pop','pop_14','pop_15_64','pop_65',
            'pop_age','pop_density','pop_death_rate')

  all  <- unique(c('id','date', fast, slow))

  if(type=="slow")
    return(slow)

  if(type=="fast")
    return(fast)

  return(all)

}

