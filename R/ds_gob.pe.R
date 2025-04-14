#' Ministerio de Salud
#'
#' Data source for: Peru
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 2:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' 
#' @section Level 3:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' 
#' @source https://www.datosabiertos.gob.pe/dataset/vacunaci%C3%B3n-contra-covid-19-ministerio-de-salud-minsa
#'
#' @keywords internal
#'
gob.pe <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  # download vaccines
  options(timeout = 600)  
  zip <- tempfile()
  outdir <- tempdir()
  
  url <- "https://files.minsa.gob.pe/s/J8C75Y55nkFazWF/download"
  download.file(url, zip, mode = "wb", quiet = TRUE)
  
  # unzip, read, and delete
  unzip(zip, exdir = outdir)
  
  inner_file <- list.files(outdir, pattern = "vacunas_covid\\.7z$", full.names = TRUE, recursive = TRUE)[1]

  system(sprintf("7za x %s -o%s -y", shQuote(inner_file), shQuote(outdir)))

  x <- data.table::fread(file.path(outdir, "vacunas_covid.csv"), showProgress = FALSE)

  unlink(zip)
  
  # format
  x <- map_data(x, c(
    "FECHA_VACUNACION" = "date",
    "DOSIS" = "dose",
    "FABRICANTE" = "type",
    "DEPARTAMENTO" = "department",
    "PROVINCIA" = "province",
    "DISTRITO" = "district"
  ))
  
  # grouping by level
  by <- switch(level,
    "1" = c("date"),
    "2" = c("date", "department"),
    "3" = c("date", "department", "district"))
    
  # vaccines
  x <- x %>%
    # for each date and area
    group_by_at(by) %>%
    # compute people vaccinated and total doses
    summarise(
      vaccines = n(),
      people_vaccinated = sum(dose==1),
      people_fully_vaccinated = sum(dose==2)) %>%
    # group by area
    group_by_at(by[-1]) %>%
    # sort by date
    arrange(date) %>%
    # cumulate
    mutate(
      vaccines = cumsum(vaccines),
      people_vaccinated = cumsum(people_vaccinated),
      people_fully_vaccinated = cumsum(people_fully_vaccinated))
  
  # remove rows with empty department 
  if ("department" %in% colnames(x)) x <- x[x$department != "", ]
  
  
  # convert date
  x$date <- as.Date(as.character(x$date), format = "%Y%m%d")
  
  return(x)
}
