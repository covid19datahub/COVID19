library(COVID19)
library(eurostat)
library(geosphere)
library(data.table)

readGADM <- function(iso, level){
  # import
  url <- sprintf("https://biogeo.ucdavis.edu/data/gadm3.6/Rsp/gadm36_%s_%s_sp.rds", iso, level-1)
  file <- tempfile()
  download.file(url, file)
  g <- readRDS(file)
  # inner point
  p <- sf::st_point_on_surface(sf::st_as_sf(g))
  p <- sf::as_Spatial(p)
  # plot
  sp::plot(g)
  points(p, col = "magenta")
  # to data.frame
  x <- data.frame(p)
  colnames(x) <- map_values(colnames(x), c("coords.x1" = "longitude", "coords.x2" = "latitude"))
  # return
  return(x)
}

fillGADM <- function(x, iso, admin_level){
  # download
  url <- sprintf("https://biogeo.ucdavis.edu/data/gadm3.6/Rsp/gadm36_%s_%s_sp.rds", iso, admin_level-1)
  file <- tempfile()
  download.file(url, file)
  g <- readRDS(file)
  # to fill
  if(length(idx <- which(is.na(x$key_gadm)))){
    key_gadm <- apply(x[idx,], 1, function(x){
      coords <- matrix(as.numeric(c(x[['longitude']], x[['latitude']])), ncol = 2)
      if(any(is.na(coords))) return(NA)
      area <- sp::over(sp::SpatialPoints(coords, proj4string = sp::CRS(sp::proj4string(g))), g)
      area[[sprintf("GID_%s", admin_level-1)]]
    })    
  }
  # fill and return
  x$key_gadm[idx] <- key_gadm
  return(x)
}

fillNUTS <- function(x, admin_level, nuts_level){
  geo_nuts <- get_eurostat_geospatial(nuts_level = nuts_level, output_class = "spdf", resolution = "01", year = "2021")
  key_nuts <- apply(x, 1, function(x){
    coords <- matrix(as.numeric(c(x[['longitude']], x[['latitude']])), ncol = 2)
    if(any(is.na(coords))) return(NA)
    sp::over(sp::SpatialPoints(coords, proj4string = sp::CRS(sp::proj4string(geo_nuts))), geo_nuts)$NUTS_ID
  })
  if(is.null(x$key_nuts)){
    x$key_nuts <- NA
  }
  idx <- which(is.na(x$key_nuts) & x$administrative_area_level==admin_level)
  x$key_nuts[idx] <- key_nuts[idx]
  return(x)
}

fillLevel2 <- function(x){
  idx <- which(x$administrative_area_level==2)
  lev <- gsub("\\_.*$", "", x$key_gadm)
  upr <- gsub("\\.[^\\.]*$", "", x$key_gadm)
  map <- x$administrative_area_level_2[idx]
  names(map) <- lev[idx]
  x$administrative_area_level_2[-idx] <- map_values(upr[-idx], map, force = TRUE)
  return(x)
}

fillGoogle <- function(x){
  if(is.null(x$key_google_mobility)){
    x$key_google_mobility <- NA
  }
  gkey <- regions::google_nuts_matchtable
  map <- gkey$google_region_name
  names(map) <- gkey$code_2016
  idx <- which(is.na(x$key_google_mobility))
  x$key_google_mobility[idx] <- map_values(x$key_nuts[idx], map, force = TRUE)
  return(x)
}

format <- function(x){
  if(all(!is.na(x$id))){
    if(is.null(x$key_local)) x$key_local <- NA
    x$key_local <- as.character(x$key_local)
    x <- dplyr::bind_rows(data.frame(key_local = "-"), x)
  }
  x <- x[,order(colnames(x))]
  i <- startsWith(colnames(x), "id")
  x <- x[, c(which(i), which(!i))]
  x <- x[order(x$administrative_area_level, x$administrative_area_level_2, x$administrative_area_level_3, na.last = FALSE),]
  if(sum(is.na(x$id))!=1){
    stop("Some ids are NA")
  }
  if(any(duplicated(x$id))){
    stop("Some ids are duplicated")
  }
  idx2 <- which(x$administrative_area_level==2)
  idx3 <- which(x$administrative_area_level==3)
  if(length(idx2) > 0 & length(idx3) > 0){
    if(any(!x$administrative_area_level_2[idx3] %in% c(NA, x$administrative_area_level_2[idx2]))){
      warning("Not all admin3 are in admin2")
    }
  }
  if(!is.null(x$key_gadm)){
    if(sum(is.na(x$key_gadm))>1){
      warning("Some key_gadm are NAs")
    }
    idx <- which(!is.na(x$key_gadm))
    if(any(duplicated(paste(x$administrative_area_level[idx], x$key_gadm[idx])))){
      warning("Duplicated key_gadm") 
    }
  }
  if(!is.null(x$key_hasc)){
    idx <- which(!is.na(x$key_hasc))
    if(any(duplicated(paste(x$administrative_area_level[idx], x$key_hasc[idx])))){
      warning("Duplicated key_hasc") 
    }
    n <- sapply(strsplit(x$key_hasc, split = "\\."), length)
    i <- which(n!=x$administrative_area_level & !is.na(x$key_hasc))
    if(length(i)>0){
      warning("key_hasc do not match with administrative_area_level") 
    }
  }
  if(!is.null(x$key_google_mobility)){
    if(any(duplicated(na.omit(x$key_google_mobility)))){
      warning("Duplicated key_google_mobility") 
    }
  }
  if(!is.null(x$key_local)){
    idx <- which(!is.na(x$key_local))
    if(any(duplicated(paste(x$administrative_area_level[idx], x$key_local[idx])))){
      stop("Duplicated key_local") 
    }
  }
  if(!all((colnames(x) %in% c(
    "id","latitude","longitude","population", "administrative_area_level", 
    "administrative_area_level_2", "administrative_area_level_3",
    "key_local", "key_hasc", "key_gadm", "key_nuts", 
    "key_google_mobility", "key_apple_mobility", "key_jhu_csse",
    "population_data_source", "population_data_source_url")) 
    | startsWith(colnames(x), "id_"))){
    stop("Some colnames are not allowed")
  }
  if(!is.null(x$key_nuts)){
    if(any(duplicated(na.omit(x$key_nuts)))){
      warning("Duplicated key_nuts") 
    }
  }
  if(sum(is.na(x$latitude))>1){
    warning("latitude contains NA values") 
  }
  if(sum(is.na(x$longitude))>1){
    warning("longitude contains NA values") 
  }
  if(sum(is.na(x$population))>1){
    warning("population contains NA values") 
  }
  return(x)
}

fillx <- function(x, y, id.x, id.y, var.x, var.y, level){
  map <- y[[var.y]]
  names(map) <- y[[id.y]]
  idx <- which(x$administrative_area_level==level & is.na(x[[var.x]]))
  if(is.null(x[[var.x]])) x[[var.x]] <- NA
  x[[var.x]][idx] <- map_values(x[[id.x]][idx], map, force = TRUE)
  return(x)
}

# CSV
iso <- "ARG"
x <- extdata(sprintf("db/%s.csv", iso))

# GADM
g <- readGADM(iso = iso, level = 3)
View(g)


x <- fillx(x = x, y = g, level = 3,
           id.x = "key", id.y = "key", 
           var.x = "key_gadm", var.y = "GID_2")

x <- fillx(x = x, y = g, level = 3,
           id.x = "key_gadm", id.y = "GID_2", 
           var.x = "longitude", var.y = "longitude")

# population
file <- file.choose()
p <- read.csv(file, sep = "\t")
p$Population <- as.integer(gsub(",", "", p$Population))

x <- fillx(x = x, y = p, level = 2,
           id.x = "key_hasc", id.y = "HASC", 
           var.x = "population", var.y = "Population")

x$population_data_source <- "Statoids (2006)"
x$population_data_source_url <- "http://www.statoids.com/uaf.html"

# Apple mobility
a <- fread("inst/extdata/apple.csv", header = TRUE)[,1:6]
a$key <- gsub(", $", "", paste(a$region, a$`sub-region`, sep = ", "))
View(a)

# Google mobility
g <- fread("inst/extdata/google.csv", encoding = "UTF-8", na.strings = "")[,1:8]
g <- g[g$country_region_code=="AR",]
g <- g[!duplicated(g),]
View(g)

g <- g[is.na(g$sub_region_2),]

g$sub_region_1 <- trimws(gsub(" Province$", "", g$sub_region_1))

x <- fillx(x = x, y = g, level = 2,
           id.x = "administrative_area_level_2", id.y = "sub_region_1", 
           var.x = "key_google_mobility", var.y = "place_id")


# JHU CSSE
jhu <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19_Unified-Dataset/master/COVID-19_LUT.csv")
j <- jhu[jhu$ISO1_3C==iso,]
View(j)

# x <- fillNUTS(x, admin_level = 3, nuts_level = 3)
# x <- fillGADM(x, admin_level = 3, iso = iso)
# x <- fillLevel2(x)
# x <- fillGoogle(x)

x <- format(x)
fwrite(x, file = sprintf("inst/extdata/db/%s.csv", iso), quote = TRUE)

