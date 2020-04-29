oxcgrt <- function(cache){
  
  # download
  url <- "https://ocgptweb.azurewebsites.net/CSVDownload/?type=Compressed"
  x   <- read.csv(url, cache = cache)
  
  # formatting
  colnames(x) <- mapvalues(colnames(x), c(
    "Date"                                    = "date",
    "CountryCode"                             = "iso_alpha_3",
    "S1_School.closing"                       = "school_closing",
    "S2_Workplace.closing"                    = "workplace_closing",
    "S3_Cancel.public.events"                 = "cancel_events",
    "S4_Close.public.transport"               = "transport_closing",
    "S5_Public.information.campaigns"         = "information_campaigns",
    "S6_Restrictions.on.internal.movement"    = "internal_movement_restrictions",
    "S7_International.travel.controls"        = "international_movement_restrictions",
    "S8_Fiscal.measures"                      = "fiscal_measures",
    "S9_Monetary.measures"                    = "monetary_measures",
    "S10_Emergency.investment.in.health.care" = "investment_healthcare",
    "S11_Investment.in.Vaccines"              = "investment_vaccines",
    "S12_Testing.framework"                   = "testing_framework",
    "S13_Contact.tracing"                     = "contact_tracing",
    "StringencyIndexForDisplay"               = "stringency_index"
  ))
  
  # date
  x$date <- as.Date(as.character(x$date), format = "%Y%m%d")
  
  # return
  return(x)
  
}

