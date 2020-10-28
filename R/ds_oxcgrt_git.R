oxcgrt_git <- function(level, cache){
  
  # download
  url <- "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv"
  x   <- read.csv(url, cache = cache)

  # add global flags
  x$C8_Flag <- 1
  x$H2_Flag <- 1
  x$H3_Flag <- 1
  
  # formatting
  x <- map_data(x, c(
    "Date"                                    = "date",
    "CountryCode"                             = "iso_alpha_3",
    "RegionCode"                              = "region_code",
    
    "C1_School.closing"                       = "school_closing",
    "C2_Workplace.closing"                    = "workplace_closing",
    "C3_Cancel.public.events"                 = "cancel_events",
    "C4_Restrictions.on.gatherings"           = "gatherings_restrictions",
    "C5_Close.public.transport"               = "transport_closing",
    "C6_Stay.at.home.requirements"            = "stay_home_restrictions",
    "C7_Restrictions.on.internal.movement"    = "internal_movement_restrictions",
    "C8_International.travel.controls"        = "international_movement_restrictions",
    
    "C1_Flag"                                 = "school_closing_flag",
    "C2_Flag"                                 = "workplace_closing_flag",
    "C3_Flag"                                 = "cancel_events_flag",
    "C4_Flag"                                 = "gatherings_restrictions_flag",
    "C5_Flag"                                 = "transport_closing_flag",
    "C6_Flag"                                 = "stay_home_restrictions_flag",
    "C7_Flag"                                 = "internal_movement_restrictions_flag",
    "C8_Flag"                                 = "international_movement_restrictions_flag",
    
    "H1_Public.information.campaigns"         = "information_campaigns",
    "H2_Testing.policy"                       = "testing_policy",
    "H3_Contact.tracing"                      = "contact_tracing",
    
    "H1_Flag"                                 = "information_campaigns_flag",
    "H2_Flag"                                 = "testing_policy_flag",
    "H3_Flag"                                 = "contact_tracing_flag",
    
    "StringencyIndexForDisplay"               = "stringency_index"))
  
  # flag columns
  cols <- c(
    "school_closing",
    "workplace_closing",
    "cancel_events",
    "gatherings_restrictions",
    "transport_closing",
    "stay_home_restrictions",
    "internal_movement_restrictions",
    "international_movement_restrictions",
    "information_campaigns",
    "testing_policy",
    "contact_tracing")
  
  # date
  x$date <- as.Date(as.character(x$date), format = "%Y%m%d")
  
  # country level
  if(level == 1) {
    
    # only country data
    x <- x[is.na(x$region_code),]
    
    # add id
    x$oxcgrt_id <- x$iso_alpha_3
    
  }
  # lower levels
  else {
    
    # split regions/country
    idx <- which(!is.na(x$region_code))
    r <- x[idx,]
    x <- x[-idx,]
    
    # add id
    x$oxcgrt_id <- x$iso_alpha_3
    r$oxcgrt_id <- r$region_code
    
    # remove not countrywise data
    for(col in cols) {
      flag <- paste(col, "flag", sep = "_")
      idx <- which(x[[flag]]==0 | is.na(x[[flag]]))
      x[idx, col] <- NA
    }
    
    # merge regional data
    if(level==2){
      x <- rbind(x, r)
    }
    
  }

  # return
  return(x)
  
}
