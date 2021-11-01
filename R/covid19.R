#' COVID-19 Data Hub
#'
#' @param country vector of country names or \href{https://github.com/covid19datahub/COVID19/blob/master/inst/extdata/db/ISO.csv}{ISO codes} (alpha-2, alpha-3 or numeric).
#' @param level integer. Granularity level. 1: country-level data. 2: state-level data. 3: city-level data.
#'
#' @source \url{https://covid19datahub.io}
#'
#' @references 
#' Guidotti, E., Ardia, D., (2020), "COVID-19 Data Hub", Journal of Open Source Software 5(51):2376, \doi{10.21105/joss.02376}.
#'
#' @keywords internal
#' 
#' @export
#' 
covid19 <- function(country = NULL, level = 1){
  
  # fallback
  if(!(level %in% 1:3))
    stop("Valid options for 'level' are:
         1: admin area level 1
         2: admin area level 2
         3: admin area level 3")
  
  # ISO 
  iso <- extdata("db", "ISO.csv")
  iso <- mutate_if(iso, is.integer, as.character)
  
  # load all csv files
  db <- bind_rows(lapply(iso$iso_alpha_3, function(i){
    extdata(sprintf("db/%s.csv", i)) %>%
      as.data.frame() %>%
      mutate_if(is.integer, as.character) %>%
      mutate(iso_alpha_3 = i)
  })) 
  
  # add level 1 data
  cols <- c("iso_alpha_3", "iso_alpha_2", "iso_numeric", "iso_currency", "administrative_area_level_1")
  db <- left_join(db, iso[,cols], by = "iso_alpha_3")
  db <- bind_rows(db, iso)
  
  # drop missing id
  db <- db[!is.na(db$id),]
  
  # download data
  x <- data.frame()
  if(is.null(country)) country <- iso$id
  for(fun in country) if(exists(fun, envir = asNamespace("COVID19"), mode = "function", inherits = FALSE)) {
    
    # try 
    y <- try(do.call(fun, args = list(level = level)))
    
    # skip on NULL
    if(is.null(y))
      next
    
    # check error
    if("try-error" %in% class(y)){
      warning(sprintf("%s: try-error", fun))
      next
    }
    
    # subset
    y <- y[,intersect(colnames(y), c('id', 'date', vars('cases')))]
    
    # add country code
    y$iso_alpha_3 <- fun

    # add id for level 1    
    if(level==1)
      y$id <- fun
    
    # check format
    if(!ds_check_format(y, level = level, ci = 0.85)){
      warning(sprintf("%s: check failed", fun))
      next
    }
    
    # add data
    x <- bind_rows(x, y)
    
  }
  
  # filter
  x <- x[!is.na(x$id),]
  
  # check empty
  if(!nrow(x))
    return(NULL)
  
  # policy measures
  o <- github.oxcgrt.covidpolicytracker(level = level)
  
  # add oxcgrt id
  map <- db$id_github.oxcgrt.covidpolicytracker
  names(map) <- db$id
  x$id_oxcgrt <- map[x$id]
  
  # fallback to country when id is missing
  idx <- which(is.na(x$id_oxcgrt))
  x$id_oxcgrt[idx] <- x$iso_alpha_3[idx]
  
  # merge policy measures
  x <- left_join(x, o, by = c('date','id_oxcgrt'))
  
  # fill missing columns and subset
  key <- c('id', 'date', vars('cases'), vars('measures'))
  x[,key[!(key %in% colnames(x))]] <- NA
  x <- x[,key]
  
  # merge top level data
  x <- left_join(x, db[,intersect(colnames(db), c("id", vars("admin")))], by = "id")
  
  # fill missing columns and subset
  cn <- vars()
  x[,cn[!(cn %in% colnames(x))]] <- NA
  x <- x[,cn]
  
  # type conversion
  x <- x %>% 
    dplyr::mutate_at('date', as.Date) %>%
    dplyr::mutate_at(vars('integer'), as.integer) %>%
    dplyr::mutate_at(vars('numeric'), as.numeric) %>%
    dplyr::mutate_at(vars('character'), as.character)
  
  # order by id and date
  x <- arrange(x, id, date)
  
  # check missing dates
  if(length(which(idx <- is.na(x$date))))
    stop(sprintf("column 'date' contains NA values: %s", paste0(unique(x$id[idx]), collapse = ", ")))
  
  # check duplicated dates
  if(length(idx <- which(duplicated(x[,c("id", "date")]))))
    stop(sprintf("multiple dates per id: %s", paste0(unique(x$id[idx]), collapse = ", ")))
  
  # check date range
  if(any(x$date<"2020-01-01" | x$date>Sys.Date()))
    stop("Some dates are out of range")
  
  # check duplicated names
  idx <- which(duplicated(x[,c('date','administrative_area_level_1','administrative_area_level_2','administrative_area_level_3')]))
  if(length(idx))
    stop(sprintf("the tuple ('date','administrative_area_level_1','administrative_area_level_2','administrative_area_level_3') is not unique: %s", paste(unique(x$id[idx]), collapse = ", ")))
  
  # return
  x
  
}

#' Generate link to the file at the GitHub repository
#' 
#' @param x name of the iso_ or ds_ function, or name of the .csv file
#' 
#' @keywords internal
#' 
#' @export
repo <- function(x, csv = FALSE){
  master <- "https://github.com/covid19datahub/COVID19/blob/master" 
  if(csv){
    url <- sprintf("%s/inst/extdata/db/%s.csv", master, x)
  }
  else{
    prefix <- ifelse(grepl("^[A-Z]{3}$", x), "iso", "ds")
    url <- sprintf("%s/R/%s_%s.R", master, prefix, x)
  }
  return(url)
}

#' Naming convention
#' 
#' @param x the return of a ds_ funtion
#' 
#' @keywords internal
#' 
#' @export
naming <- function(x){
  n <- na.omit(map_values(colnames(x), force = TRUE, c(
    "confirmed"               = "0 confirmed cases",
    "deaths"                  = "1 deaths",
    "recovered"               = "2 recovered",
    "tests"                   = "3 tests",
    "vaccines"                = "4 total vaccine doses administered",  
    "people_vaccinated"       = "5 people with at least one vaccine dose", 
    "people_fully_vaccinated" = "6 people fully vaccinated", 
    "hosp"                    = "7 hospitalizations",  
    "icu"                     = "8 intensive care",  
    "vent"                    = "9 patients requiring ventilation"
  )))
  gsub("^..", "", sort(n))
}

#' Generate docstring to use in the ds_ files
#' 
#' @param ds the name of the ds_ R function
#' @param name the name of the data provider
#' @param desc the name(s) of the countries supported by the data provider, e.g., "United States".
#' @param url the link to the data provider
#' @param ... arguments passed to the ds_ function
#' 
#' @keywords internal
#' 
#' @export
ds_docstring <- function(ds, name, desc, url, ...){
  variables <- lapply(1:3, function(level){
    x <- do.call(ds, args = c(list(level = level), list(...)))
    if(is.null(x)) return(NULL)
    naming(x)    
  })
  levels <- which(!sapply(variables, is.null))
  sections <- sapply(levels, function(level){
    v <- variables[[level]]
    s <- paste("#' -", v, collapse = "\n")
    sprintf("#' @section Level %s:\n%s\n", level, s)
  })
  sections <- paste(sections, collapse = "#'\n")
  params <- sprintf("#' @param level %s\n", paste(levels, collapse = ", "))
  extra <- setdiff(names(formals(ds)), "level")
  if(length(extra)){
    extra <- sapply(extra, function(p) sprintf("#' @param %s <INSERT DESCRIPTION HERE>\n", p))
    params <- paste(c(params, extra), collapse = "")
  }
  cat(sprintf(
    "#' %s\n#'\n#' Data source for: %s\n#'\n%s#'\n%s#'\n#' @source %s\n#'\n#' @keywords internal\n#'", 
    name, desc, params, sections, url))
}

#' Generate docstring to use in the iso_ files
#' 
#' @param ds the name of the ds_ R function
#' @param ... arguments passed to the ds_ function
#' 
#' @keywords internal
#' 
#' @export
iso_docstring <- function(ds, ...){
  x <- do.call(ds, args = list(...))
  n <- naming(x)
  t <- gsub("#' ", "", readLines(sprintf("R/ds_%s.R", ds))[1], fixed = TRUE)
  cat(sprintf('#\' - \\href{`r repo("%s")`}{%s}:\n#\' %s.\n#\'\n', ds, t, paste(n, collapse = ",\n#' ")))
}

#' Generate docstring to use in the iso_ files to list the population data source
#' 
#' @param iso the ISO code of the country
#' @param level 1, 2, 3
#' 
#' @keywords internal
#' 
#' @export
docstring <- function(iso, level){
  if(level==1){
    x <- extdata("db/ISO.csv") %>% dplyr::filter(id==iso)
    url <- repo("ISO", csv = TRUE)
  }
  else{
    x <- extdata(sprintf("db/%s.csv", iso))
    url <- repo(iso, csv = TRUE)
  }
  ds <- na.omit(unique(x$population_data_source[x$administrative_area_level==level]))
  if(length(ds)==0) return(NULL)
  ds <- sprintf("\\href{%s}{%s}", url, ds)  
  sprintf(" - %s: population.", paste(ds, collapse = ", "))
}

cachedata <- new.env(hash = TRUE)
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

#' Convert identifiers
#'
#' Map the ids of administrative areas used by the data provider to the 
#' identifiers used in the Data Hub.
#' 
#' @param x vector of identifiers used by the data source to identify administrative areas.
#' @param iso the 3 letter ISO code of the country.
#' @param ds the name of the data source function.
#' @param level the level of the administrative areas.
#' 
#' @return converted vector of identifiers to use in the Data Hub.
#' 
#' @keywords internal
#' 
#' @export
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
  
  cum <- c(
    'numeric' = 'confirmed',
    'numeric' = 'deaths',
    'numeric' = 'recovered',
    'numeric' = 'tests',
    'numeric' = 'vaccines',
    'numeric' = 'people_vaccinated',
    'numeric' = 'people_fully_vaccinated'
  )
  
  spot <- c(
    'numeric' = 'hosp',
    'numeric' = 'icu',
    'numeric' = 'vent'
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
    'integer' = 'facial_coverings',
    'integer' = 'vaccination_policy',
    'integer' = 'elderly_people_protection',
    'numeric' = 'government_response_index',
    'numeric' = 'stringency_index',
    'numeric' = 'containment_health_index',
    'numeric' = 'economic_support_index'
  )
  
  admin <- c(
    'character' = 'iso_alpha_3',
    'character' = 'iso_alpha_2',
    'integer'   = 'iso_numeric',
    'character' = 'iso_currency',
    'integer'   = 'administrative_area_level',
    'character' = 'administrative_area_level_1',
    'character' = 'administrative_area_level_2',
    'character' = 'administrative_area_level_3',
    'numeric'   = 'latitude',
    'numeric'   = 'longitude',
    'integer'   = 'population',
    'character' = 'key_local',
    'character' = 'key_google_mobility',
    'character' = 'key_apple_mobility',
    'character' = 'key_jhu_csse',
    'character' = 'key_nuts',
    'character' = 'key_gadm'
  )
  
  if(is.null(type))
    return(unname(unique(c('id', 'date', cum, spot, 'population', measures, admin))))
  
  if(type=="cum")
    return(unname(cum))
  
  if(type=="spot")
    return(unname(spot))
  
  if(type=="measures")
    return(unname(measures))
    
  if(type=="admin")
    return(unname(admin))
  
  if(type=="cases")
    return(unname(c(cum, spot)))
  
  all <- c(cum, spot, measures, admin)
  all <- all[which(names(all)==type)]
  return(unname(all))
  
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
#' @keywords internal
#' 
#' @export
cumsum <- function(x, na.rm = TRUE){
  
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
#' @keywords internal
#' 
#' @export
extdata <- function(...){
  
  file <- system.file("extdata", ..., package = "COVID19")
  if(!file.exists(file))
    return(NULL)
  
  utils::read.csv(file, na.strings = "", stringsAsFactors = FALSE, encoding = "UTF-8")
  
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
#' @param level integer. Granularity level. 1: country-level data. 2: state-level data. 3: city-level data.
#' 
#' @return \code{data.frame}
#' 
#' @keywords internal
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
#' @keywords internal
#' 
#' @export
map_values <- function(x, map, force = FALSE){
  
  value <- tolower(x)
  from  <- tolower(names(map))
  to    <- map
  
  if(force)
    y <- rep(NA, length(x))
  else 
    y <- x
  
  for(i in 1:length(map)){
    idx <- which(value==from[i])
    if(length(idx)>0)
      y[idx] <- to[i]
  }
  
  return(y)
  
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
#' @keywords internal
#' 
#' @export
map_data <- function(x, map){
  
  cn <- names(map)
  if(is.null(cn))
    cn <- map
  
  idx <- which(cn=="")
  if(length(idx))
    cn[idx] <- unname(map)[idx]
  
  x <- x[,intersect(cn, colnames(x)), drop = FALSE]
  colnames(x) <- map_values(colnames(x), map)
  
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
#' @keywords internal
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
#' @keywords internal
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
#' @keywords internal
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
#' @keywords internal
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
#' @keywords internal
#' 
#' @export
ds_check_format <- function(x, level, ci = 0.95) {
  
  check <- function(c, message) {
    c <- mean(c, na.rm = TRUE) > ci
    if(is.na(c)) 
      c <- TRUE
    if(!c) 
      warning(message)
    return(c)
  }
  
  # fallback
  if(!any(vars("cases") %in% colnames(x))){
    warning("no valid column detected. Please rename the columns according to the documentation available at https://covid19datahub.io/articles/doc/data.html")
    return(FALSE)
  }
  
  # id missing 
  if(!("id" %in% colnames(x))){
    if(level>1){
      warning("column 'id' missing. Please add the id for each location (required for level > 1)")
      return(FALSE)
    }
    else{ 
      x$id <- "id"
    }
  }
  
  # subset
  x      <- x[!is.na(x$id),]
  x      <- x[, apply(x, 2, function(x) any(!is.na(x))), drop=FALSE]
  cols   <- colnames(x)
  status <- TRUE
  
  # date missing 
  if(!("date" %in% cols)){
    warning("column 'date' missing. Please add the date for each observation")
    return(FALSE)
  }
  
  # NA dates
  if(any(is.na(x$date))){
    warning("column date contains NA values")
    return(FALSE)
  }
  
  # check date column is date
  status <- status & check(inherits(x$date, c("Date")),
                           "column date of wrong type")
  
  # check duplicated dates
  if(length(idx <- which(duplicated(x[,c("id", "date")])))){
    warning(sprintf("multiple dates per id: %s", paste0(unique(x$id[idx]), collapse = ", ")))
    return(FALSE)
  }
  
  # check data types
  for(col in intersect(cols, c('tests','confirmed','recovered','deaths','hosp','vent','icu'))){
    if(!is.numeric(x[[col]])){
      warning(sprintf("%s not of class numeric", col))
      return(FALSE)
    }
  }
  
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
  # vent <= icu
  if("vent" %in% cols & "icu" %in% cols)
    status <- status & check(ci < mean(x$vent <= x$icu | x$icu == 0, na.rm = T),
                             "vent > icu")
  
  # check cumulative/non-cumulative
  y <- x %>%
    
    dplyr::mutate(
      deaths    = if("deaths" %in% cols) deaths else 0,
      confirmed = if("confirmed" %in% cols) confirmed else 0,
      tests     = if("tests" %in% cols) tests else 0,
      vaccines  = if("vaccines" %in% cols) vaccines else 0,
      people_vaccinated       = if("people_vaccinated" %in% cols) people_vaccinated else 0,
      people_fully_vaccinated = if("people_fully_vaccinated" %in% cols) people_fully_vaccinated else 0,
      recovered = if("recovered" %in% cols) recovered else 0,
      hosp      = if("hosp" %in% cols) hosp else 0,
      vent      = if("vent" %in% cols) vent else 0,
      icu       = if("icu" %in% cols) icu else 0 ) %>%
    
    dplyr::group_by_at('id') %>%
    dplyr::arrange_at('date') %>%
    
    # detect negative derivation
    dplyr::summarise(
      d_deaths_nonneg    = ci < mean(diff(deaths)    >= 0, na.rm = T),
      d_confirmed_nonneg = ci < mean(diff(confirmed) >= 0, na.rm = T),
      d_tests_nonneg     = ci < mean(diff(tests)     >= 0, na.rm = T),
      d_vaccines_nonneg  = ci < mean(diff(vaccines)     >= 0, na.rm = T),
      d_people_vaccinated_nonneg       = ci < mean(diff(people_vaccinated)     >= 0, na.rm = T),
      d_people_fully_vaccinated_nonneg = ci < mean(diff(people_fully_vaccinated)     >= 0, na.rm = T),
      d_recovered_nonneg = ci < mean(diff(recovered) >= 0, na.rm = T),
      d_hosp_anyneg      = all(hosp==0, na.rm = T) | any(diff(hosp) < 0, na.rm = T),
      d_vent_anyneg      = all(vent==0, na.rm = T) | any(diff(vent) < 0, na.rm = T),
      d_icu_anyneg       = all(icu==0, na.rm = T)  | any(diff(icu)  < 0, na.rm = T) )
  
  # deaths not descending
  status <- status & check(y$d_deaths_nonneg,
                           "are you sure 'deaths' are cumulative counts?")
  # confirmed not descending
  status <- status & check(y$d_confirmed_nonneg,
                           "are you sure 'confirmed' are cumulative counts?")
  # tests not descending
  status <- status & check(y$d_tests_nonneg,
                           "are you sure 'tests' are cumulative counts?")
  
  # vaccines not descending
  status <- status & check(y$d_vaccines_nonneg,
                           "are you sure 'vaccines' are cumulative counts?")
  
  # people_vaccinated not descending
  status <- status & check(y$d_people_vaccinated_nonneg,
                           "are you sure 'people_vaccinated' are cumulative counts?")
  
  # people_fully_vaccinated not descending
  status <- status & check(y$d_people_fully_vaccinated_nonneg,
                           "are you sure 'people_fully_vaccinated' are cumulative counts?")
  
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
  
  # return
  return(status)
}
