oxcgrt_git <- function(cache){
  
  # download
  url <- "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv"
  x   <- read.csv(url, cache = cache)
  
  # TODO filter by level...
  #x <- x[is.na(x$RegionCode),]
  
  # formatting
  xx <- map_data(x, c(
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
    
    "H1_Public.information.campaigns"         = "information_campaigns",
    "H2_Testing.policy"                       = "testing_policy",
    "H3_Contact.tracing"                      = "contact_tracing",
    
    "StringencyIndexForDisplay"               = "stringency_index"
  ))
  
  #xx$school_closing <- 1
  #xx$school_closing_flag <- 0
  
  # operations with restrictions
  #check_restrict_country <- function(col,flag) (col != 0) & !is.na(flag) & (flag == 1)
  check_restrict_region  <- function(col,flag) (col != 0) & !is.na(flag) & (flag == 0)
  #check_country_restrict_country <- function(region,col,flag) is.na(region) & check_restrict_country(col,flag)
  check_country_restrict_region  <- function(region,col,flag) is.na(region) & check_restrict_region(col,flag)
  #check_country_restrict_unknown <- function(region,col,flag) is.na(region) & (col != 0) & is.na(flag)
  #check_region_restrict_country  <- function(region,col,flag) !is.na(region) & check_restrict_country(col,flag)
  #check_region_restrict_region   <- function(region,col,flag) !is.na(region) & check_restrict_region(col,flag)
  #check_region_restrict_unknown  <- function(region,col,flag) !is.na(region) & (col != 0) & is.na(flag)
  
  # loop columns
  for(col in c("school_closing","workplace_closing","cancel_events","gatherings_restrictions","transport_closing",
               "stay_home_restrictions","internal_movement_restrictions")) {
    flag <- paste(col, "flag", sep = "_")
    # convert to columns
    col  <- rlang::sym(col)
    flag <- rlang::sym(flag)
    # change data based on flags
    xx <- xx %>%
      dplyr::group_by(iso_alpha_3) %>%
      dplyr::mutate(
        # set column to NA for all country records if flag is set to regional
        UQ(col) := ifelse(check_country_restrict_region(region_code,UQ(col),UQ(flag)),NA,UQ(col))
      )
  }
  
  # date
  xx$date <- as.Date(as.character(xx$date), format = "%Y%m%d")
  
  #View(xx[which(!is.na(xx$region_code)),])
  
  # add IDs to csv file
  
  # return
  return(x)
  
}

