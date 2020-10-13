bag_ch <- function(cache){
  
  # source
  url <- 'https://www.bag.admin.ch/dam/bag/it/dokumente/mt/k-und-i/aktuelle-ausbrueche-pandemien/2019-nCoV/covid-19-datengrundlage-lagebericht.xlsx.download.xlsx/200325_dati%20di%20base_grafica_COVID-19-rapporto.xlsx'
  
  # download
  x <- read.excel(url, cache=cache, sheet=1, skip=6)
  
  # format
  x <- map_data(x, c(
    "Data"                         = "date",
    "Numero di casi, cumulato"     = "confirmed",
    "Numero di decessi, cumulati"  = "deaths",
    "Numero di casi ospedalizzati" = "hosp"
  ))
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
  
}
