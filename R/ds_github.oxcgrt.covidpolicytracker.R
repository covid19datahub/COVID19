#' Oxford Covid-19 Government Response Tracker
#'
#' Data source for: Worldwide
#' Documentation: https://covid19datahub.io/articles/docs.html#policy-measures
#'
#' @param level 1, 2, 3
#'
#' @source https://github.com/OxCGRT/covid-policy-tracker
#'
#' @keywords internal
#'
github.oxcgrt.covidpolicytracker <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  # download"BRA" "CAN" "CHN" "GBR" "USA"
  url <- "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker-legacy/main/legacy_data_202207/OxCGRT_latest.csv"
  x   <- read.csv(url, cache = TRUE)

  # issue a warning if new sub-national data are available
  codes <- unique(x$CountryCode[!is.na(x$RegionCode)])
  new <- setdiff(codes, c("AUS", "BRA", "CAN", "CHN", "GBR", "IND", "USA"))
  if(length(new)>0) warning(sprintf("OxCGRT: New sub-national level are available: %s", new))
  
  # C8, H2, H3, H7 have no binary flag for geographic scope
  # -> they do not vary within the country 
  # -> set flag=1 (general policy)
  x$C8_Flag <- 1
  x$H2_Flag <- 1
  x$H3_Flag <- 1
  x$H7_Flag <- 1
  
  # formatting
  x <- map_data(x, c(
    "Date"                                    = "date",
    "CountryCode"                             = "iso_alpha_3",
    "RegionCode"                              = "region_code",
    "C1_School.closing"                       = "school_closing",
    "C1_Flag"                                 = "school_closing_flag",
    "C2_Workplace.closing"                    = "workplace_closing",
    "C2_Flag"                                 = "workplace_closing_flag",
    "C3_Cancel.public.events"                 = "cancel_events",
    "C3_Flag"                                 = "cancel_events_flag",
    "C4_Restrictions.on.gatherings"           = "gatherings_restrictions",
    "C4_Flag"                                 = "gatherings_restrictions_flag",
    "C5_Close.public.transport"               = "transport_closing",
    "C5_Flag"                                 = "transport_closing_flag",
    "C6_Stay.at.home.requirements"            = "stay_home_restrictions",
    "C6_Flag"                                 = "stay_home_restrictions_flag",
    "C7_Restrictions.on.internal.movement"    = "internal_movement_restrictions",
    "C7_Flag"                                 = "internal_movement_restrictions_flag",
    "C8_International.travel.controls"        = "international_movement_restrictions",
    "C8_Flag"                                 = "international_movement_restrictions_flag",
    "H1_Public.information.campaigns"         = "information_campaigns",
    "H1_Flag"                                 = "information_campaigns_flag",
    "H2_Testing.policy"                       = "testing_policy",
    "H2_Flag"                                 = "testing_policy_flag",
    "H3_Contact.tracing"                      = "contact_tracing",
    "H3_Flag"                                 = "contact_tracing_flag",
    "H6_Facial.Coverings"                     = "facial_coverings", 
    "H6_Flag"                                 = "facial_coverings_flag",
    "H7_Vaccination.policy"                   = "vaccination_policy",
    "H7_Flag"                                 = "vaccination_policy_flag",
    "H8_Protection.of.elderly.people"         = "elderly_people_protection",
    "H8_Flag"                                 = "elderly_people_protection_flag",
    "GovernmentResponseIndex"                 = "government_response_index",
    "StringencyIndex"                         = "stringency_index",
    "ContainmentHealthIndex"                  = "containment_health_index",
    "EconomicSupportIndex"                    = "economic_support_index"))
  
  # define flags, policy, and index columns  
  cn <- colnames(x)
  flags <- cn[endsWith(cn, "_flag")]
  value <- gsub("\\_flag", "", flags)
  index <- cn[endsWith(cn, "_index")]
  
  # set negative values for policies with missing flag or flag equal to zero
  x[,flags][is.na(x[,flags])] <- 0
  x[,value] <- x[,value] * sign(x[,flags]-0.5)
  
  # country level
  if(level == 1) {
    
    # nothing to do

  }
  
  # sub-national level
  if(level==2) {

    # do not alter sub-national index
    # set negative values for country-level index
    idx <- is.na(x$region_code)
    x[idx, index] <- -x[idx, index]
    
  }
  
  # municipality level
  if(level==3){

    # OxCGRT has no data at the municipality level
    # set negative values for all index
    x[, index] <- -x[, index]
    
  }
  
  # date
  x$date <- as.Date(as.character(x$date), format = "%Y%m%d")
  
  # create identifier with country code for countries, and region code for regions
  x$id_oxcgrt <- ifelse(is.na(x$region_code), x$iso_alpha_3, x$region_code)
  
  return(x)
}
