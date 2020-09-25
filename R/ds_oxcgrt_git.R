oxcgrt_git <- function(level, cache){
  
  # download
  url <- "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv"
  x   <- read.csv(url, cache = cache)

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
    
    "H1_Public.information.campaigns"         = "information_campaigns",
    "H2_Testing.policy"                       = "testing_policy",
    "H3_Contact.tracing"                      = "contact_tracing",
    
    "StringencyIndexForDisplay"               = "stringency_index"))
  # columns
  cols <- c("school_closing","cancel_events","internal_movement_restrictions",
            "workplace_closing","gatherings_restrictions","transport_closing",
            "stay_home_restrictions")

  # date
  x$date <- as.Date(as.character(x$date), format = "%Y%m%d")
  
  # country level
  if(level == 1) {
    
    # only country data
    Rs <- x %>%
      dplyr::filter(is.na(region_code))
    
    # loop columns
    for(col in cols) {
      flag <- paste(col, "flag", sep = "_")
      
      # flag only regionally
      Rs[,col] = ifelse(!is.na(Rs[,flag]) & (Rs[,flag] == 0), NA, Rs[,col])
    }
    
  }
  # regional level
  else {
    
    Rs  <- NULL
    
    # loop columns
    for(col in cols) {
      flag <- paste(col, "flag", sep = "_")
      
      # propagate country policies to regions
      r <- x %>%
        # country records
        dplyr::filter(is.na(region_code) &
                      !is.na(UQ(rlang::sym(flag))) &
                      (UQ(rlang::sym(flag)) == 1)) %>%
        dplyr::select(date, iso_alpha_3, region_code, UQ(rlang::sym(col)))
      
      # regional restrictions
      rr <- x %>%
        # regional records
        dplyr::filter(!is.na(region_code) &
                      !is.na(UQ(rlang::sym(flag))) &
                      (UQ(rlang::sym(flag)) == 0)) %>%
        dplyr::select(date, iso_alpha_3, region_code, UQ(rlang::sym(col)))
      
      # join restrictions
      r <- rbind(r, rr)
      print(r)
      # TODO: what if both is on (invalid option)
      
      # append
      if(is.null(Rs)) Rs <- r
      else Rs <- Rs %>%
        dplyr::full_join(r, by = c("date", "iso_alpha_3", "region_code"))
      
      # region code
      Rs <- Rs %>% dplyr::rename(id_oxcgrt_git = region_code)
    }
    
  }
  
  # return
  return(Rs)
  
}

oxf <- oxcgrt_git(2,F)
