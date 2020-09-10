
cachedata <- new.env()

x <- oxcgrt_git(1, T)
y <- oxcgrt_git(2, T)

Nx <- nrow(x)
Ny <- nrow(y)

cols <- c(
  "gatherings_restrictions","workplace_closing","internal_movement_restrictions",
  "school_closing","transport_closing","stay_home_restrictions","cancel_events"
)

#df <- data.frame()
for(col in cols) {
  flag <- paste(col, "flag", sep = "_")
  
  country.missing <- which(                                                             is.na(x[,flag]) )
  country.country <- which( is.na(x$region_code) & !is.na(x[,col]) & !is.na(x[,flag]) & (x[,flag] == 1) )
  country.region  <- which( is.na(x$region_code) &  is.na(x[,col]) & !is.na(x[,flag]) & (x[,flag] == 0) )
  region.missing  <- which(                                           is.na(y[,flag])                   )
  region.country  <- which( is.na(y$region_code)                                      | is.na(x[,flag]) )
  region.global   <- which(!is.na(y$region_code) & !is.na(y[,col]) & !is.na(y[,flag]) & (y[,flag] == 1) )
  region.region   <- which(!is.na(y$region_code)                   & !is.na(y[,flag]) & (y[,flag] == 0) )
  
  country <- x[-unique(c(country.missing, country.country, country.region)),]
  region  <- y[-unique(c(region.missing, region.country, region.global, region.region)),]
  
  print(col)
  print(country[,c("region_code",col,flag)])
  print(region[,c("region_code",col,flag)])
  
  
  #df <- rbind(df, c(
  #  nrow(x[country.missing,]) / Nx,
  #  nrow(x[country.country,]) / Nx,
  #  nrow(x[country.region,]) / Nx,
  #  nrow(y[region.missing,]) / Ny,
  #  nrow(y[region.country,]) / Ny,
  #  nrow(y[region.region,]) / Ny
  #))
}

#colnames(df) <- c("Level1.Missing","Level1.Countrywise","Level1.Regionwise",
#                  "Level2.Missing","Level2.Countrywise","Level2.Regionwise")
#print(df)
