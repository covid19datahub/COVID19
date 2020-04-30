mzcr <- function(level, cache){
  # Author: Martin Benes
  
  # mzcr - Ministery of Health of Czech Republic
  mzcr.covid.api <- "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19"
  mzcr.covid.url <- "https://onemocneni-aktualne.mzcr.cz/covid-19"
  
  if(level == 1) {
    # number of tests
    url   <- sprintf("%s/testy.csv", mzcr.covid.api)
    tests <- read.csv(file = url, cache = cache)
    
    # number of infected
    url       <- sprintf("%s/nakaza.csv", mzcr.covid.api)
    confirmed <- read.csv(url, cache = cache)
    
    # date
    tests$date     <- as.Date(tests[,1])
    confirmed$date <- as.Date(confirmed[,1]) 
    # select columns
    tests     <- subset(tests, select=c(date,testy_celkem))
    confirmed <- subset(confirmed, select=c(date,pocet_celkem)) 
    
    # formatting
    x           <- merge(tests, confirmed, by="date", all=T)
    x$date      <- as.Date(x[,1])
    x$tests     <- x$testy_celkem
    x$confirmed <- x$pocet_celkem
  }
  if(level == 2) {
    # people confirmed (by regions)
    url    <- sprintf("%s/osoby.csv", mzcr.covid.api)
    people <- read.csv(url, cache = cache)
    
    # regional
    people$date  <- as.Date(people$X.U.FEFF.datum_hlaseni)
    people$state <- people$kraj
    
    # group
    x <- people %>%
      dplyr::group_by(date,state) %>%
      dplyr::summarize(
        confirmed             = n(),
        female_ratio          = sum(!is.na(pohlavi)            & pohlavi == "Z")          / length(pohlavi),
        male_ratio            = sum(!is.na(pohlavi)            & pohlavi == "M")          / length(pohlavi),
        infected_abroad_ratio = sum(!is.na(nakaza_v_zahranici) & nakaza_v_zahranici == 1) / length(nakaza_v_zahranici),
        age_14_ratio          = sum(!is.na(vek)                & vek <= 14)               / length(vek),
        age_15_64_ratio       = sum(!is.na(vek)                & vek >= 15 & vek <= 64)   / length(vek),
        age_65_ratio          = sum(!is.na(vek)                & vek >= 65)               / length(vek)
      )
  }
  
  # return
  return(x)
  
}
