#' @importFrom dplyr %>%
NULL



.onAttach <- function(libname, pkgname) {

  if(interactive() & requireNamespace('COVID19', quietly = TRUE)){

    packageStartupMessage("The coronavirus situation is changing fast. Checking for updates...")

    description <- readLines('https://raw.githubusercontent.com/emanuele-guidotti/COVID19/master/DESCRIPTION')
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
  x <- try(remotes::install_github('emanuele-guidotti/COVID19', quiet = FALSE, upgrade = FALSE), silent = TRUE)
  library(COVID19)

}



db <- function(id, type = NULL){

  if(!is.null(type)){
    map <- c('country' = 1, 'state' = 2, 'city' = 3)
    id  <- paste0(id,"-",map[type])
  }

  utils::read.csv(system.file("extdata", "db", paste0(id,".csv"), package = "COVID19"), na.strings = "", stringsAsFactors = FALSE)

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
    x <- x[,cn]
    x <- x[!duplicated(x),]
  }

  if(!is.null(ISO))
    x <- dplyr::bind_rows(db(ISO), x)

  x <- x[!duplicated(x),]
  x[,cn[!(cn %in% colnames(x))]] <- NA
  x <- dplyr::arrange(x, -rowSums(is.na(x)), x$state, x$city)

  if(save & !is.null(ISO))
    utils::write.csv(x, paste0(ISO,".csv"), row.names = FALSE, na = "")

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

  if(class(x)=="try-error")
    x <- NULL

  if(cache)
    assign(key, x, envir = cachedata)

  return(x)

}


read.csv <- function(file, cache, na.strings = "", stringsAsFactors = FALSE, ...){

  if(cache)
    x <- cachecall(utils::read.csv, file = file, na.strings = na.strings, stringsAsFactors = stringsAsFactors, ...)
  else
    x <- utils::read.csv(file = file, na.strings = na.strings, stringsAsFactors = stringsAsFactors, ...)

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

