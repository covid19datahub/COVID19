#' @importFrom dplyr %>%
NULL

# .onAttach <- function(libname, pkgname) {
# 
#   if(interactive() & requireNamespace('COVID19', quietly = TRUE)){
# 
#     packageStartupMessage("The coronavirus situation is changing fast. Checking for updates...")
# 
#     description <- try(readLines('https://raw.githubusercontent.com/covid19datahub/COVID19/master/DESCRIPTION'), silent = TRUE)
#     if(class(description)=="try-error")
#       return()
#       
#     id <- which(startsWith(prefix = "Version:", x = description))
#     v  <- as.package_version(gsub(pattern = "^Version:\\s*", replacement = "", x = description[id]))
# 
#     if(v > utils::packageVersion(pkg = "COVID19")){
# 
#       yn <- utils::askYesNo("Package COVID19: new version available. Update now?")
#       if(!is.na(yn)) if(yn)
#         update()
# 
#     } else {
# 
#       packageStartupMessage("...up to date.")
# 
#     }
# 
#   }
# 
#   packageStartupMessage(
#     '
#     ================================================================\n
#     
#     IMPORTANT NOTICE: 
#     This is the development version of the COVID-19 Data Hub
#     
#     Download the stable release from CRAN:
#     install.packages("COVID19")
#     
#     ================================================================\n
#     '
#   )
#   
# }
# 
# update <- function(){
# 
#   detach("package:COVID19", unload=TRUE)
#   x <- try(remotes::install_github('covid19datahub/COVID19', quiet = FALSE, upgrade = FALSE), silent = TRUE)
#   library(COVID19)
# 
# }

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

fix <- function(x, iso){
  
  x$date <- as.character(x$date)
  x <- x %>% dplyr::bind_rows(extdata("fix",sprintf("%s.csv",iso)))
  x <- x[!duplicated(x$date, fromLast = TRUE),]
  x$date <- as.Date(x$date)
  
  return(x)
  
}

id <- function(x, iso, ds, level){
  
  db <- extdata("db",sprintf("%s.csv",iso))
  db <- db[which(db$administrative_area_level==level),]
  
  map        <- db$id
  names(map) <- db[[sprintf("id_%s",ds)]]
  
  x   <- map_values(x, map)
  idx <- which(!(x %in% map))
  if(length(idx)){
    warning(sprintf("missing id: %s", paste0(unique(x[idx]), collapse = ", ")))
    x[idx] <- NA
  }
    
  return(x)
  
}

vars <- function(type = NULL){
  
  cases <- c(
    'numeric' = 'tests',
    'numeric' = 'confirmed',
    'numeric' = 'recovered',
    'numeric' = 'deaths',
    'numeric' = 'hosp',
    'numeric' = 'vent',
    'numeric' = 'icu'
    # 'numeric' = 'severe'
  )
  
  measures <- c(
    'integer' = 'school_closing',
    'integer' = 'workplace_closing',
    'integer' = 'cancel_events',
    'integer' = 'gatherings_restrictions',
    'integer' = 'transport_closing',
    'integer' = 'stay_home_restrictions',
    'integer' = 'internal_movement_restrictions',
    'integer' = 'international_movement_restrictions',
    'integer' = 'information_campaigns',
    'integer' = 'testing_policy',
    'integer' = 'contact_tracing',
    'numeric' = 'stringency_index'
  )
  
  fast <- c(cases, measures)
  
  slow <- c(
    'character' = 'iso_alpha_3',
    'character' = 'iso_alpha_2',
    'integer'   = 'iso_numeric',
    'character' = 'currency',
    'character' = 'administrative_area_level',
    'character' = 'administrative_area_level_1',
    'character' = 'administrative_area_level_2',
    'character' = 'administrative_area_level_3',
    'numeric'   = 'latitude',
    'numeric'   = 'longitude',
    'numeric'   = 'population'
  )
  
  if(is.null(type))
    return(unname(unique(c('id','date',cases,'population',measures,slow))))
    
  if(type=="slow")
    return(unname(slow))
    
  if(type=="fast")
    return(unname(fast))
    
  if(type=="test")
    return(unname(unique(c('id','date',cases,slow))))
  
  all <- c(fast, slow)
  all <- all[which(names(all)==type)]
  return(unname(all))
  
}

cite <- function(x, src, verbose){
  
  x <- x %>% 
    
    dplyr::group_by_at('iso_alpha_3') %>%
    
    dplyr::group_map(function(x, iso){
      
      iso   <- iso[[1]]
      level <- unique(x$administrative_area_level)
      
      var   <- apply(x, 2, function(x) !all(is.na(x) | x==0))
      var   <- names(var)[var]
      
      s     <- src[which(src$data_type %in% var & src$iso_alpha_3==iso & src$administrative_area_level==level),]
      var   <- var[!(var %in% s$data_type)]
      
      if(length(var)>0)
        s <- s %>% 
        dplyr::bind_rows(src[which(src$data_type %in% var & is.na(src$iso_alpha_3) & is.na(src$administrative_area_level)),])
      
      s$iso_alpha_3 <- iso
      s$administrative_area_level <- level  
      
      return(s)
      
    }) %>%
    
    dplyr::bind_rows() %>%
    
    dplyr::distinct()
  
  if(verbose){
    
    y <- x %>% 
      dplyr::mutate(url = gsub("(http://|https://|www\\.)([^/]+)(.*)", "\\1\\2", url)) %>%
      dplyr::distinct_at(c('title', 'url'), .keep_all = TRUE)
    
    y <- apply(y, 1, function(y){
      
      textVersion <- y['textVersion']
      if(is.na(textVersion))
        textVersion <- paste0(y['title'],' (',y['year'],')',', ',y['url'])
      
      utils::bibentry(
        bibtype     = ifelse(is.na(y['bibtype']), "Misc", y['bibtype']),
        title       = y['title'],
        year        = y['year'],
        author      = y['author'],
        institution = y['institution'], 
        textVersion = textVersion
      )  
      
    })
    
    cit <- utils::citation("COVID19")
    for(i in 1:length(y))
      cit <- c(y[[i]], cit)
    
    print(cit, style = "citation")
    cat("To hide the data sources use 'verbose = FALSE'.")
    
  }
  
  return(x)
  
}

is_equal <- function(x, y){
  
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

csv_check_data <- function(iso){
  
  iso <- toupper(iso)
  x   <- read.csv(sprintf("https://raw.githubusercontent.com/covid19datahub/COVID19/master/inst/extdata/db/%s.csv", iso), cache = FALSE)
  y   <- extdata("db",sprintf("%s.csv",iso))
  
  return(is_equal(x, y))
  
}

#' Cumulative Sums
#' 
#' Returns a numeric object whose elements are the cumulative sums of the elements of the argument.
#' 
#' @param x a numeric object.
#' @param na.rm logical. Should missing values be removed? Default \code{FALSE}.
#' 
#' @details 
#' If \code{na.rm=TRUE}, then \code{NA} are treated as \code{0} when computing the cumulative sum.
#' 
#' @examples 
#' \dontrun{
#' 
#' x <- mtcars[1:5,]
#' x[2,] <- NA
#' 
#' cumsum(x)
#' cumsum(x, na.rm = TRUE)
#' 
#' }
#' 
#' @export
cumsum <- function(x, na.rm = FALSE){
  
  if(!na.rm)
    return(base::cumsum(x))
  
  miss <- is.na(x)
  x[miss] <- 0
  
  x <- base::cumsum(x)
  x[miss] <- NA
  
  return(x)
  
}

#' External Data
#' 
#' Read files in the inst/extdata/ folder.
#' 
#' @param ... path to file
#' 
#' @return \code{data.frame}
#' 
#' @examples 
#' \dontrun{
#' 
#' # read file inst/extdata/db/ISO.csv
#' x <- extdata("db","ISO.csv")
#' 
#' }
#' 
#' @export
extdata <- function(...){
  
  file <- system.file("extdata", ..., package = "COVID19")
  if(!file.exists(file))
    return(NULL)
  
  utils::read.csv(file, na.strings = "", stringsAsFactors = FALSE, encoding = "UTF-8")
  
}

#' Add Data Source
#' 
#' Add data source to the file inst/extdata/src.csv
#' 
#' @param ... named arguments corresponding to the columns of the \href{https://github.com/covid19datahub/COVID19/tree/master/inst/extdata/src.csv}{src.csv} file.
#' 
#' @return \code{data.frame}.
#' 
#' @examples 
#' \dontrun{
#' 
#'  x <- add_src(
#'   iso_alpha_3 = "USA", 
#'   administrative_area_level = 1, 
#'   data_type = "confirmed", 
#'   url = "https://example.com", 
#'   title = "New Data Source", 
#'   year = 2020)
#'   
#' }
#' 
#' @export
add_src <- function(...){

  new <- data.frame(list(...), stringsAsFactors = FALSE)
  
  if(nrow(new)>0){
    req <- c("iso_alpha_3","administrative_area_level","data_type","url","title","year")
    req <- req[!(req %in% names(new))]
    if(length(req)>0)
      stop(sprintf("The following arguments are required: %s", paste(req, collapse = ", ")))
  }
  
  file <- "src.csv"
  if(file.exists(file))
    x <- read.csv(file, cache = FALSE)
  else
    x <- extdata(file)
  
  x$year <- as.character(x$year)
  
  x <- x %>%
    dplyr::bind_rows(new) %>%
    dplyr::distinct(iso_alpha_3, administrative_area_level, data_type, url, .keep_all = TRUE) %>%
    dplyr::arrange(iso_alpha_3, administrative_area_level) 
    
    
  write.csv(x, file)
  cat(sprintf("File saved: %s", file))
  
  return(x)
  
}

#' Add XXX.csv file
#' 
#' Add new country in the inst/extdata/db/ folder
#' 
#' @param x \code{data.frame} generated by a data source function.
#' @param iso ISO code (3 letters).
#' @param ds name of the data source function generating \code{x}.
#' @param map named vector mapping the columns of \code{x} to the columns of the XXX.csv file.
#' @param append logical. Append the data to the XXX.csv file if it already exists? Default \code{TRUE}.
#' 
#' @return \code{data.frame}
#' 
#' @examples 
#' \dontrun{
#' 
#' # download data
#' x <- COVID19:::jhucsse_git(file = "US", cache = TRUE, level = 3, country = "USA")
#' 
#' # add iso
#' csv <- add_iso(x, iso = "USA", ds = "jhucsse_git", level = 3, map = c(
#'  "id"    = "id", 
#'  "state" = "administrative_area_level_2", 
#'  "city"  = "administrative_area_level_3",
#'  "pop"   = "population",
#'  "lat"   = "latitude",
#'  "lng"   = "longitude",
#'  "fips"  = "key_numeric"))
#'  
#' }
#' 
#' @export
add_iso <- function(x, iso, ds, level, map = c("id"), append = TRUE){
  
  if(!level %in% 2:3)
    stop("level must be 2 or 3")
  
  id_ds <- sprintf("id_%s", ds)
  key   <- c('id',id_ds,'administrative_area_level','administrative_area_level_2','administrative_area_level_3','latitude','longitude','population')
  map   <- c(map, key[!(key %in% map)])
  
  x <- map_data(x, map)
  x <- x[!duplicated(x),,drop=FALSE]
  if(!("id" %in% colnames(x)))
    stop("specify the 'id' column using the 'map' argument, eg. map = c('column' = 'id')")
  
  x[[id_ds]] <- x$id 
  x$id       <- sapply(x$id, FUN = function(x) digest::digest(c(iso, x), algo = 'crc32'))
  
  x[,key[!(key %in% colnames(x))]] <- NA
  x$administrative_area_level      <- level
  
  file <- sprintf("%s.csv", iso)
  
  if(append){
    
    if(file.exists(file))
      y <- read.csv(file, cache = FALSE)
    else
      y <- extdata("db", file)
    
    x <- dplyr::bind_rows(y, x)
    
  }
  
  cn  <- colnames(x)
  key <- unique(c("id", cn[grepl("^id\\_", cn)], key, cn[grepl("^key(\\_|$)", cn)]))
  x   <- x[,key]
  
  write.csv(x, file)
  cat(sprintf("File saved: %s", file))
  
  return(x)
  
}

#' Map values
#' 
#' Map values of a vector.
#' 
#' @param x vector.
#' @param map named vector mapping names to values.
#' 
#' @return \code{vector}.
#' 
#' @examples 
#' \dontrun{
#' 
#' x <- c('red','green','red','blue')
#' 
#' map_values(x, map = c(
#' 'red' = 'yellow', 
#' 'blue' = 'orange'))
#' 
#' }
#' 
#' @export
map_values <- function(x, map){

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

#' Map Data
#' 
#' Subset a \code{data.frame} and change column names.
#' 
#' @param x \code{data.frame}
#' @param map named vector. Map columns of \code{x} and subset.
#' 
#' @return \code{data.frame}
#' 
#' @examples 
#' \dontrun{
#' 
#' x <- mtcars
#' 
#' map_data(x, c(
#' 'cyl' = 'Cylinders',
#' 'hp'  = 'Gross horsepower'
#' ))
#' 
#' }
#' 
#' @export
map_data <- function(x, map){
  
  if(!is.null(names(map)))
    colnames(x) <- map_values(colnames(x), map)
  
  return(x[, intersect(map, colnames(x)), drop = FALSE])
  
}

#' Merge Two Data Frames
#' 
#' Merge two data frames by common columns or row names, or do other versions of database join operations.
#' Drop common columns of the second data.frame.
#' 
#' @param ... arguments passed to \code{\link[base]{merge}}
#' 
#' @return return value of \code{\link[base]{merge}}
#' 
#' @export
merge <- function(...){

  # merge
  x   <- base::merge(..., suffixes = c('','.drop'))
  cn  <- colnames(x)
  
  # check duplicates
  idx <- which(endsWith(cn, '.drop'))
  if(length(idx)>0){
    
    # replace NA
    for(j in idx){
      dup <- gsub("\\.drop$", "", cn[j])
      i   <- is.na(x[,dup]) & !is.na(x[,j])  
      if(any(i))
        x[i,dup] <- x[i,j]
    }
    
    # drop duplicates
    x <- x[,-idx]
    
  }
  
  # return
  return(x)

}

#' Data Output
#' 
#' Write csv in UTF-8.
#' 
#' @param x the object to be written, preferably a matrix or data frame. If not, it is attempted to coerce x to a data frame.
#' @param file either a character string naming a file or a connection open for writing. "" indicates output to the console.
#' @param row.names either a logical value indicating whether the row names of x are to be written along with x, or a character vector of row names to be written.
#' @param na the string to use for missing values in the data.
#' @param fileEncoding character string: if non-empty declares the encoding to be used on a file (not a connection) so the character data can be re-encoded as they are written. 
#' @param ... arguments passed to \code{\link[utils:write.table]{write.csv}}
#' 
#' @return return value of \code{\link[utils:write.table]{write.csv}}
#' 
#' @export
write.csv <- function(x, file, row.names = FALSE, na = "", fileEncoding = "UTF-8", ...){
  
  utils::write.csv(x, file = file, row.names = row.names, na = na, fileEncoding = fileEncoding, ...)
    
}

#' Data Input (csv)
#' 
#' Reads a file in table format and creates a data frame from it, with cases corresponding to lines and variables to fields in the file.
#' 
#' @param file the name of the file which the data are to be read from. Each row of the table appears as one line of the file. If it does not contain an absolute path, the file name is relative to the current working directory, getwd(). Tilde-expansion is performed where supported. This can be a compressed file.
#' @param cache logical. Memory caching? Default \code{FALSE}.
#' @param na.strings a character vector of strings which are to be interpreted as \code{NA} values. Blank fields are also considered to be missing values in logical, integer, numeric and complex fields. Note that the test happens after white space is stripped from the input, so \code{na.strings} values may need their own white space stripped in advance.
#' @param stringsAsFactors logical: should character vectors be converted to factors?
#' @param encoding encoding to be assumed for input strings. It is used to mark character strings as known to be in Latin-1 or UTF-8: it is not used to re-encode the input, but allows R to handle encoded strings in their native encoding. 
#' @param ... arguments passed to \code{\link[utils:write.table]{read.csv}}
#' 
#' @return return value of \code{\link[utils:write.table]{read.csv}}
#' 
#' @export
read.csv <- function(file, cache = FALSE, na.strings = "", stringsAsFactors = FALSE, encoding = "UTF-8", ...){

  if(cache)
    x <- cachecall(utils::read.csv, file = file, na.strings = na.strings, stringsAsFactors = stringsAsFactors, encoding = encoding, ...)
  else
    x <- utils::read.csv(file = file, na.strings = na.strings, stringsAsFactors = stringsAsFactors, encoding = encoding, ...)

  return(x)

}

#' Data Input (excel)
#' 
#' Read xls and xlsx files.
#' 
#' @param path Path to the xls/xlsx file.
#' @param cache logical. Memory caching? Default \code{FALSE}.
#' @param sheet Sheet to read. Either a string (the name of a sheet), or an integer (the position of the sheet). Ignored if the sheet is specified via range. If neither argument specifies the sheet, defaults to all sheets.
#' @param ... arguments passed to \code{\link[readxl]{read_excel}}
#' 
#' @return list of \code{data.frame}
#' 
#' @examples 
#' \dontrun{
#' 
#' url <- "https://epistat.sciensano.be/Data/COVID19BE.xlsx"
#' x   <- read.excel(url, cache = TRUE)  
#' 
#' }
#' 
#' @export
read.excel <- function(path, cache = FALSE, sheet = NA, ...) {
  
  # read excel from url
  read_excel <- function(path, sheet, ...) {
    
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
  
  # is url (readxl::read_excel supports only http, https, ftp)
  if(grepl(x = path, pattern = "^(http:\\/\\/)|(https:\\/\\/)|(ftp:\\/\\/)")) 
    reader <- read_excel
  # local file
  else
    reader <- readxl::read_excel
  
  if(cache)
    x <- cachecall(reader, path = path, sheet = sheet, ...)
  else
    x <- reader(path = path, sheet = sheet, ...)
  
  return(x)
  
}

#' Data Input (zip)
#' 
#' Reads files from a zip folder.
#' 
#' @param zip path (url) to the zip folder.
#' @param files vector of filenames to read inside the zip folder.
#' @param cache logical. Memory caching? Default \code{FALSE}.
#' @param ... arguments passed to \code{\link{read.csv}} or \code{\link{read.excel}}.
#' 
#' @return list of \code{data.frames}
#' 
#' @examples 
#' \dontrun{
#' 
#' url <- "https://info.gesundheitsministerium.at/data/data.zip"
#' 
#' x   <- read.zip(url, cache = TRUE, sep = ";", files = c(
#' "confirmed" = "Epikurve.csv",
#' "deaths"    = "TodesfaelleTimeline.csv",
#' "recovered" = "GenesenTimeline.csv"))
#' 
#' }
#' 
#' @export
read.zip <- function(zip, files, cache = FALSE, ...){
  
  read.zip <- function(zip, files, ...){
    
    temp <- tempfile()
    utils::download.file(zip, temp, quiet = TRUE)  
    
    lapply(files, function(file){
    
      if(grepl("\\.xlsx?$", file))
        x <- readxl::read_excel(unz(temp, file), ...)
      else
        x <- read.csv(unz(temp, file), cache = FALSE, ...)
      
      return(x)
      
    })
    
  }
  
  if(cache)
    x <- cachecall(read.zip, zip = zip, files = files, ...)
  else 
    x <- read.zip(zip = zip, files = files, ...)
  
  return(x)
  
}


#' Error Log
#' 
#' Error log of the \code{\link{covid19}} output.
#' 
#' @param x \code{data.frame} generated by the function \code{\link{covid19}}
#' 
#' @return \code{data.frame}
#' 
#' @examples 
#' \dontrun{
#' 
#' x <- covid19(level = 2)
#' e <- err_log(x)
#' 
#' }
#' 
#' @export
err_log <- function(x){
  
  err <- list()
  key <- c("date","iso_alpha_3","administrative_area_level_1","administrative_area_level_2","administrative_area_level_3","tests","confirmed","deaths","recovered","hosp","vent","icu")
  
  idx <- which(x$deaths > x$confirmed & x$confirmed != 0) 
  if(length(idx))
    err$`More deaths then confirmed cases` <- x[idx,key]
  
  
  idx <- which(x$confirmed > x$tests & x$tests != 0) 
  if(length(idx))
    err$`More confirmed cases than tests` <- x[idx,key]
  
  
  idx <- which(x$recovered > x$confirmed & x$confirmed != 0) 
  if(length(idx))
    err$`More recovered then confirmed cases` <- x[idx,key]
  
  idx <- which(x$hosp > x$confirmed & x$confirmed != 0) 
  if(length(idx))
    err$`More hospitalized then confirmed cases` <- x[idx,key]
  
  idx <- which(x$icu > x$hosp & x$hosp != 0) 
  if(length(idx))
    err$`More ICU then hospitalized` <- x[idx,key]
  
  idx <- which(x$vent > x$confirmed & x$confirmed != 0) 
  if(length(idx))
    err$`More people requiring ventilation then confirmed cases` <- x[idx,key]
  
  x <- x %>%
    dplyr::arrange_at('date') %>%
    dplyr::group_by_at('id') %>%
    dplyr::mutate(
      'deaths.err'    = c(NA, diff(deaths)<0),
      'confirmed.err' = c(NA, diff(confirmed)<0),
      'tests.err'     = c(NA, diff(tests)<0),
      'recovered.err' = c(NA, diff(recovered)<0)
    )
  
  idx <- which(x$deaths.err) 
  if(length(idx))
    err$`Cumulative number of deaths smaller than previous day` <- x[idx,key]
  
  idx <- which(x$confirmed.err) 
  if(length(idx))
    err$`Cumulative number of confirmed cases smaller than previous day` <- x[idx,key]
  
  idx <- which(x$tests.err) 
  if(length(idx))
    err$`Cumulative number of tests smaller than previous day` <- x[idx,key]
  
  idx <- which(x$recovered.err) 
  if(length(idx))
    err$`Cumulative number of recovered smaller than previous day` <- x[idx,key]
  
  err <- dplyr::bind_rows(err, .id = "error")  
  
  return(err)
  
}

#' Check Data Source Format
#' 
#' Checks if the output of a data source function is correctly formatted. 
#' The function checks the FORMAT, NOT the DATA.
#' Before submission, the data should be double checked by comparing with external data sources (e.g. Google search).
#' 
#' @param x output of a data source function.
#' @param level integer. Granularity level. 1: country-level data. 2: state-level data. 3: city-level data.
#' 
#' @return logical. 
#' 
#' @examples 
#' \dontrun{
#' 
#' # check format of the 'pcmdpc_git' data source
#' x <- COVID19:::pcmdpc_git(cache = FALSE, level = 1)
#' ds_check_format(x, level = 1)
#' 
#' }
#' 
#' @export
ds_check_format <- function(x, level) {
  
  check <- function(c, message) {
    if(!(c <- all(c))) 
      warning(message)
    return(c)
  }
  
  status <- TRUE
  ci     <- 0.95
  cols   <- colnames(x)
  
  # fallback
  if(!any(vars("fast") %in% cols))
    stop("no valid column detected. Please rename the columns according to the documentation available at https://covid19datahub.io/articles/doc/data.html")
  
  # id missing 
  if(!("id" %in% cols)){
    if(level>1)
      stop("column 'id' missing. Please add the id for each location (required for level > 1)")
    else 
      x$id <- "id"
  }
  
  # date missing 
  if(!("date" %in% cols))
    stop("column 'date' missing. Please add the date for each observation")
  
  # check date column is date
  status <- status & check(inherits(x$date, c("Date")),
                           "column date of wrong type")
  
  # deaths <= confirmed
  if("confirmed" %in% cols & "deaths" %in% cols)
    status <- status & check(ci < mean(x$deaths <= x$confirmed | x$confirmed == 0, na.rm = T),
                             "deaths > confirmed")
  # confirmed <= tests
  if("confirmed" %in% cols & "tests" %in% cols) 
    status <- status & check(ci < mean(x$confirmed <= x$tests | x$tests == 0, na.rm = T),
                             "confirmed > tests")
  # recovered <= confirmed
  if("recovered" %in% cols & "confirmed" %in% cols)
    status <- status & check(ci < mean(x$recovered <= x$confirmed | x$confirmed == 0, na.rm = T),
                             "recovered > confirmed")
  # hosp <= confirmed
  if("hosp" %in% cols & "confirmed" %in% cols)
    status <- status & check(ci < mean(x$hosp <= x$confirmed | x$confirmed == 0, na.rm = T),
                             "hosp > confirmed")
  # icu <= hosp
  if("icu" %in% cols & "hosp" %in% cols)
    status <- status & check(ci < mean(x$icu <= x$hosp | x$hosp == 0, na.rm = T),
                             "icu > hosp")
  # vent <= confirmed
  if("vent" %in% cols & "confirmed" %in% cols)
    status <- status & check(ci < mean(x$vent <= x$confirmed | x$confirmed == 0, na.rm = T),
                             "vent > confirmed")
  
  # TODO: checks with output
  # ...

  # check ascending
  y <- x %>%
    
    dplyr::mutate(
      deaths    = if("deaths" %in% cols) deaths else 0,
      confirmed = if("confirmed" %in% cols) confirmed else 0,
      tests     = if("tests" %in% cols) tests else 0,
      recovered = if("recovered" %in% cols) recovered else 0,
      hosp      = if("hosp" %in% cols) hosp else 0,
      vent      = if("vent" %in% cols) vent else 0,
      icu       = if("icu" %in% cols) icu else 0 ) %>%
    
    dplyr::group_by_at('id') %>%
    dplyr::arrange_at('date') %>%
    
    # detect negative derivation
    dplyr::summarise(
      d_deaths_nonneg    = ci < mean(diff(deaths) >= 0, na.rm = T),
      d_confirmed_nonneg = ci < mean(diff(confirmed) >= 0, na.rm = T),
      d_tests_nonneg     = ci < mean(diff(tests) >= 0, na.rm = T),
      d_recovered_nonneg = ci < mean(diff(recovered) >= 0, na.rm = T),
      d_hosp_anyneg      = ci < mean(hosp == 0)|any(diff(hosp) < 0, na.rm = T),
      d_vent_anyneg      = ci < mean(vent == 0)|any(diff(vent) < 0, na.rm = T),
      d_icu_anyneg       = ci < mean( icu == 0)|any(diff(icu) < 0, na.rm = T) )
  
  # deaths not descending
  status <- status & check(y$d_deaths_nonneg,
                           "are you sure 'deaths' are cumulative counts?")
  # confirmed not descending
  status <- status & check(y$d_confirmed_nonneg,
                           "are you sure 'confirmed' are cumulative counts?")
  # tests not descending
  status <- status & check(y$d_tests_nonneg,
                           "are you sure 'tests' are cumulative counts?")
  # recovered not descending
  status <- status & check(y$d_recovered_nonneg,
                           "are you sure 'recovered' are cumulative counts?")
  # hosp not cumulative (any descending)
  status <- status & check(y$d_hosp_anyneg,
                           "are you sure 'hosp' are NOT cumulative counts?")
  # vent not cumulative (any descending)
  status <- status & check(y$d_vent_anyneg,
                           "are you sure 'vent' are NOT cumulative counts?")
  # icu not cumulative (any descending)
  status <- status & check(y$d_icu_anyneg,
                           "are you sure 'icu' are NOT cumulative counts?")
  # TODO: checks with output first derivation
  # ...
  
  # success
  if(status)
    message(
    "
     ====================================================================
     The format is correct!
     
     However, this function does checks the FORMAT, NOT the DATA.
     Plese double check the data via a quick Google search.
     
     When ready, submit your work. We look forward to it!
     https://github.com/covid19datahub/COVID19/wiki/Create-a-pull-request
     ====================================================================
    ")
  
  # return
  return(status)
}
