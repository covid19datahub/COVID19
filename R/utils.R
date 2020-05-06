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

src <- function(...){

  new <- data.frame(list(...), stringsAsFactors = FALSE)
  
  req <- c("iso","level","var","url","title","year")
  req <- req[!(req %in% names(new))]
  if(length(req)>0)
    stop(sprintf("The following arguments are required: %s", paste(req, collapse = ", ")))
  
  x <- try(suppressWarnings(utils::read.csv("_src.csv", na.strings = "", stringsAsFactors = FALSE, encoding = "UTF-8")), silent = TRUE)
  if(class(x)=="try-error")
    x <- db("_src")
  
  iso <- level <- NULL
  x   <- x %>%
    dplyr::bind_rows(new) %>%
    dplyr::arrange(iso,level)
  
  x <- x[!duplicated(x[,c("iso","level","var")], fromLast = TRUE), ]
    
  utils::write.csv(x, paste0("_src.csv"), row.names = FALSE, na = "", fileEncoding = "UTF-8")
  
}

csv <- function(x, ISO = NULL){
  
  if(is.null(x$id))
    stop("x must contain the column 'id'")
  
  cn <- c('id','state','city','lat','lng','pop','pop_14','pop_15_64','pop_65','pop_age','pop_density','pop_death_rate')  
  
  x[,cn[!(cn %in% colnames(x))]] <- NA
  x <- x[,cn]
  x <- x[!duplicated(x),]
  
  if(!is.null(ISO))
    x <- dplyr::bind_rows(db(ISO), x)
  
  x <- x[!duplicated(x),]
  x <- dplyr::arrange(x, -rowSums(is.na(x)), x$state, x$city)
  
  utils::write.csv(x, "XXX.csv", row.names = FALSE, na = "", fileEncoding = "UTF-8")
  
  return(x)
  
}


mapvalues <- function(x, map){

  value <- tolower(x)
  from  <- tolower(names(map))
  to    <- map

  for(i in 1:length(map)){

    idx <- which(value==from[i])
    if(length(idx)>0)
      x[idx] <- to[i]

  }

  return(x)

}



merge <- function(...){

  x   <- base::merge(..., suffixes = c('','.drop'))
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
    x <- do.call(fun, args = args)
  
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

read.zip <- function(zip, files, cache, ...){

  read.zip <- function(zip, files, ...){
    
    temp <- tempfile()
    utils::download.file(zip, temp, quiet = TRUE)  
    
    lapply(files, function(file){
      
      if(grepl("\\.csv$", file))
        x <- read.csv(unz(temp, file), cache = FALSE, ...)
      
      if(grepl("\\.xlsx?$", file))
        x <- readxl::read_excel(unz(temp, file), ...)
      
      return(x)
      
    })
    
  }
  
  if(cache)
    x <- cachecall(read.zip, zip = zip, files = files, ...)
  else 
    x <- read.zip(zip = zip, files = files, ...)
    
  return(x)
  
}

read_excel_from_url <- function(path, sheet, ...) {
  
  tmp <- tempfile()
  utils::download.file(path, destfile = tmp, mode = "wb", quiet = TRUE)
  
  # sheet not given - all sheets
  if(is.na(sheet)) {
    
    sheets <- readxl::excel_sheets(path = tmp)
    
    x <- lapply(sheets, function(X) readxl::read_excel(path = tmp, sheet = X))
    names(x) <- sheets
    
  } 
  # sheet given
  else {
    
    x <- readxl::read_excel(path = tmp, sheet = sheet, ...)
    
  }
  
  return(x)
  
}

read_excel <- function(path, cache, sheet = NA, ...) {
  
  # is url (readxl::read_excel supports only http, https, ftp)
  if(grepl(x = path, pattern = "^(http:\\/\\/)|(https:\\/\\/)|(ftp:\\/\\/)")) 
    reader <- read_excel_from_url
  # local file
  else
    reader <- readxl::read_excel
  
  if(cache)
    x <- cachecall(reader, path = path, sheet = sheet, ...)
  else
    x <- reader(path = path, sheet = sheet, ...)
  
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


test <- function(x, y){

  x <- as.data.frame(x)
  y <- as.data.frame(y)
  
  rownames(x) <- paste(x$id, x$date)
  rownames(y) <- paste(y$id, y$date)
  
  rn <- intersect(rownames(x), rownames(y))
  
  x <- x[rn, , drop = FALSE]
  y <- y[rn, , drop = FALSE]
  
  if(nrow(x)==0 | nrow(y)==0)
    return(TRUE)
  
  x <- x[,colSums(x!=0, na.rm = TRUE)!=0, drop = FALSE]
  y <- y[,colSums(y!=0, na.rm = TRUE)!=0, drop = FALSE]
  
  cn <- intersect(colnames(x), colnames(y))

  x <- x[, cn, drop = FALSE]
  y <- y[, cn, drop = FALSE]
  
  if(nrow(x)==0 | nrow(y)==0)
    return(TRUE)

  return(all.equal(x,y))
  
}


check <- function(x){
  
  id <- NULL
  
  x %>% 
    dplyr::group_by(id) %>% 
    dplyr::group_map(function(x, g){
      
      for(i in vars('fast')){
        
        graphics::plot(x[[i]]~x$date, main = paste(g[[1]], i, sep = ' - '), ylab = '', xlab = '')
        rl <- readline("Press enter: next plot \nType 's': next group \nType 'q': abort")
        
        if(rl=='s') break
        if(rl=='q') stop("aborted")
        
      }
      
    })
  
}


reduce <- function(x, map){

  if(!is.null(names(map)))
    colnames(x) <- mapvalues(colnames(x), map)

  return(x[,intersect(map, colnames(x))])
    
}


vars <- function(type = "all"){

  fast <- c('deaths','confirmed','tests','recovered',
            'hosp','icu','vent',
            'school_closing',
            'workplace_closing',
            'cancel_events',
            'gatherings_restrictions',
            'transport_closing',
            'stay_home_restrictions',
            'internal_movement_restrictions',
            'international_movement_restrictions',
            'information_campaigns',
            'testing_policy',
            'contact_tracing',
            'stringency_index',
            'mkt_close','mkt_volume')

  slow <- c('country','state','city',
            'lat','lng',
            'pop','pop_female','pop_14','pop_15_64','pop_65',
            'pop_age','pop_density','pop_death_rate',
            'hosp_beds',
            'smoking_male','smoking_female',
            'gdp','health_exp','health_exp_oop')

  all  <- unique(c('id','date', fast, slow))

  if(type=="slow")
    return(slow)

  if(type=="fast")
    return(fast)

  return(all)

}

