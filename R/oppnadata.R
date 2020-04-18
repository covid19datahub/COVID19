oppnadata <- function(cache, ...){
  #'
  #' NEW DATA SOURCE TEMPLATE
  #' This is a template to extend this package with a new data source
  #'
  #' Copy this template in a new file
  #' Rename the file with the name of the data source
  #' Rename this function with the name of the data source
  #'
  #' The function must include the argument 'cache'. See:
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/covid19.R
  #' The function can include additional arguments
  #' The function must return a data.frame
  #'
  #' Examples:
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/openZH.R
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/pcmdpc.R
  #' https://github.com/emanuele-guidotti/COVID19/blob/master/R/jhuCSSE.R
  #'
  #' @keywords internal
  #'
  
  #' Download and cache the data.
  #  Source: Public Health Agency, Sweden
  # https://oppnadata.se/datamangd/#esc_entry=1424&esc_context=525
  oppnadata.url <- "https://free.entryscape.com/store/360/resource/15"
  
  
  # number of cases, deaths, icu - whole Sweden
  oppnadata.covid <- read.csv(oppnadata.url, encoding="UTF-8")
  x <- data.frame(date=as.Date(oppnadata.covid[,28],format="%Y-%m-%d"),
                  country="SWE", state=NA,
                  confirmed=as.integer(oppnadata.covid[,2]),
                  deaths=as.integer(oppnadata.covid[,25]),
                  icu=as.integer(oppnadata.covid[,27]))
  # number of cases - regions
  for(i in 3:23) {
    region <- colnames(oppnadata.covid)[i]
    x_region <- data.frame(date=as.Date(oppnadata.covid[,28],format="%Y-%m-%d"),
                           country="SWE", state=region,
                           confirmed=as.integer(oppnadata.covid[,i]))
    x_region <- x_region[order(x_region$date),]
    x_region$confirmed <- cumsum(x_region$confirmed)
    x <- merge(x, x_region, by=c("date","country","confirmed","state"), all=T)
  }
  
  #' TODO: I was not able to get following
  #'   * deaths and icu in regions
  #'   * vent
  #'   * driving
  #'   * walking
  #'   * transit
  #'   * ...
  
  #' TODO: other datasets available
  #'   * confirmed by age: https://oppnadata.se/datamangd/#esc_entry=1425&esc_context=525
  #'   * confirmed by region: https://oppnadata.se/datamangd/#esc_entry=1426&esc_context=525
  #'   * confirmed by gender: https://oppnadata.se/datamangd/#esc_entry=1427&esc_context=525
  
  #' Include additional columns, including but not limited to:
  #' https://github.com/emanuele-guidotti/COVID19#dataset
  
  
  #' Extra
  #' filter the data, clean the data, etc.
  #' ...
  
  #' return
  return(x)
}

