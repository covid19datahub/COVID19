
msps <- function(cache, level){
 
   #Author: Federico Lo Giudice

  #' Socrata API https://dev.socrata.com/foundry/www.datos.gov.co/gt2j-8ykr
  #' Source: Ministerio de Salud y Protección Social de Colombia
 
  library(dplyr)
  library(tidyr)
  library(reshape2)
  
  #CACHE? 

  # cachekey <- "msps"
  # if(cache & exists(cachekey, envir = cachedata))
  # return(get(cachekey, envir = cachedata))
  
  
  #' Download data
  
  x  <- read.csv("https://www.datos.gov.co/resource/gt2j-8ykr.csv?$limit=50000", sep = ',', stringsAsFactors=FALSE, fileEncoding = "UTF-8") #     ?$limit=5000
  
  y  <- read.csv("https://www.datos.gov.co/resource/gdxc-w37w.csv?$limit=2000", sep = ',',stringsAsFactors=FALSE, fileEncoding = "UTF-8")
  
  
  # Dates 
  
  x$fecha_de_notificaci_n <- as.Date(x$fecha_de_notificaci_n, format = "%Y-%m-%d")
  x$fecha_diagnostico <- as.Date(x$fecha_diagnostico, format = "%Y-%m-%d")
  x$fecha_de_muerte <- as.Date(x$fecha_de_muerte, format = "%Y-%m-%d")
  x$fecha_recuperado <- as.Date(x$fecha_recuperado, format = "%Y-%m-%d")
  
  x$edad <- x$sexo <- x$tipo <- x$estado <- x$pa_s_de_procedencia <- x$fis  <- x$fecha_reporte_web <- NULL

  z = seq.Date(min(x$fecha_de_notificaci_n), max(x$fecha_de_notificaci_n), by="day")
  
  x =  mutate(x, departamento = replace(departamento, departamento == 'Cundinamara', 'Cundinamarca'))
  
 
  if(level==2){ 
  
  # merge dep codes with dates
    
  y = y %>% select(1,3) %>% distinct(cod_depto, dpto) %>%
      mutate(dpto = replace(dpto, dpto == 'Bogotá d C.', 'Bogotá D.C.'))
 
 y =  add_row(y, cod_depto = 8, dpto = "Barranquilla D.E.")
 y =  add_row(y, cod_depto =  76  ,  dpto = "Buenaventura D.E.")
 y =  add_row(y, cod_depto =  13  , dpto = "Cartagena D.T. y C.")
 y =  add_row(y, cod_depto =  47  , dpto = "Santa Marta D.T. y C.")
   
  xx = merge(y, z) 
  
  #Add  "country" column
  xx$country <- 'Colombia'
  
  # Build columns

  
  #confirmed
  
   c1 =  x[complete.cases(x[ , 8]), ] %>%
     complete(fecha_diagnostico = seq.Date(min(fecha_diagnostico), max(fecha_diagnostico), by="day"))%>%  #prima completa fecha
     complete(fecha_diagnostico, departamento) %>%  
     mutate_if(is.integer, ~replace_na(., 0)) %>%
     group_by(departamento, fecha_diagnostico) %>%
     tally() %>%
     mutate(n = cumsum(n))   
   
  # deaths 
   
  
   
   d1 =  x[complete.cases(x[ , 7]), ] %>%
         dcast(departamento + fecha_de_muerte ~ atenci_n)   %>%
         complete(fecha_de_muerte = seq.Date(min(fecha_de_muerte), max(fecha_de_muerte), by="day")) %>%  #prima completa fecha
         complete(fecha_de_muerte, departamento) %>%  #completa moltiplica fecha x departamento 
         mutate_if(is.integer, ~replace_na(., 0)) %>%
         group_by(departamento) %>%
         mutate(Fallecido = cumsum(Fallecido))   
    
  #recovered 
   
   r1 =  x[complete.cases(x[ , 9]), ] %>%
         dcast(departamento + fecha_recuperado ~ atenci_n)   %>%
         complete(fecha_recuperado = seq.Date(min(fecha_recuperado), max(fecha_recuperado), by="day"))%>%  #prima completa fecha
         complete(fecha_recuperado, departamento) %>%  #completa moltiplica fecha x departamento 
         mutate_if(is.integer, ~replace_na(., 0)) %>%
         group_by(departamento)%>%
         mutate(Recuperado = cumsum(Recuperado))
   
   
  #merge columns 
 
   xxx <- left_join(xx, c1, by = c("y"= "fecha_diagnostico", "dpto"="departamento")) %>%
       left_join(., d1, by=c("y"= "fecha_de_muerte", "dpto"="departamento")) %>%
       left_join(., r1, by=c("y"= "fecha_recuperado", "dpto"="departamento")) %>%
       unite(id, country, cod_depto, sep = " , ", remove = FALSE) #create ID
       
   xxx[is.na(xxx)]= 0 
   
  #column names 
 
   xxx =  xxx %>%
       rename( c( "date" = "y", 
                 "state" = "dpto", 
                 "confirmed" = "n", 
                 "deaths" = "Fallecido", 
                 "recovered" = "Recuperado",
                "state_id" = "cod_depto") )
  
  #reorder column
  
   xxx = xxx[ , c ("id", "date", "deaths", "confirmed", "recovered", "country", "state_id", "state") ]
   
  }
  
  

  if(level==3){ 
    
    # merge dep codes with dates
    
    xx = merge(y, z) 
    
    #Add "id" and "country" column
    
    xx$id <- 'COL'
    xx$country <- 'Colombia'
    
    
    #Build columns. 
   
    c1 =  x %>%
      complete(fecha_diagnostico = seq.Date(min(fecha_diagnostico), max(fecha_diagnostico), by="day"))%>%  #prima completa fecha
      complete(fecha_diagnostico, ciudad_de_ubicaci_n) %>%  #completa moltiplica fecha x ciudad_de_ubicaci_n 
      mutate_if(is.integer, ~replace_na(., 0)) %>%
      group_by(ciudad_de_ubicaci_n, fecha_diagnostico) %>%
      tally() %>%
      mutate(n= cumsum(n))
    

    # deaths 
    d1 =  x[complete.cases(x[ , 7]), ] %>%
      dcast(ciudad_de_ubicaci_n + fecha_de_muerte ~ atenci_n)   %>%
      complete(fecha_de_muerte = seq.Date(min(fecha_de_muerte), max(fecha_de_muerte), by="day"))%>%  #prima completa fecha
      complete(fecha_de_muerte, ciudad_de_ubicaci_n) %>%  #completa moltiplica fecha x ciudad_de_ubicaci_n 
      mutate_if(is.integer, ~replace_na(., 0)) %>%
      group_by(ciudad_de_ubicaci_n) %>%
      mutate(Fallecido = cumsum(Fallecido))   
    
    #recovered 
    r1 =  x[complete.cases(x[ , 9]), ] %>%
      dcast(ciudad_de_ubicaci_n + fecha_recuperado ~ atenci_n)   %>%
      complete(fecha_recuperado = seq.Date(min(fecha_recuperado), max(fecha_recuperado), by="day"))%>%  #prima completa fecha
      complete(fecha_recuperado, ciudad_de_ubicaci_n) %>%  #completa moltiplica fecha x ciudad_de_ubicaci_n 
      mutate_if(is.integer, ~replace_na(., 0)) %>%
      group_by(ciudad_de_ubicaci_n)%>%
      mutate(Recuperado = cumsum(Recuperado))
    
     
  #merge columns 
  
    xxx <- left_join(xx, c1, by = c("y"= "fecha_diagnostico", "nom_mpio"="ciudad_de_ubicaci_n")) %>%
          left_join(., d1, by=c("y"= "fecha_de_muerte", "nom_mpio"="ciudad_de_ubicaci_n")) %>%
          left_join(., r1, by=c("y"= "fecha_recuperado", "nom_mpio"="ciudad_de_ubicaci_n")) %>%
          unite(id, country, cod_mpio, sep = " , ", remove = FALSE)
      
   
    xxx[is.na(xxx)]= 0 
    
    #column names 
    
    xxx =  xxx %>%
      rename( c( "date" = "y", 
                 "confirmed" = "n", 
                 "deaths" = "Fallecido", 
                 "recovered" = "Recuperado",
                 "state_id" = "cod_depto",
                 "state" = "dpto", 
                 "city_id" = "cod_mpio",
                 "city"= "nom_mpio" ) )
    
    #reorder column
    
    xxx = xxx[ , c ("id", 
                    "date", 
                    "deaths", 
                    "confirmed", 
                    "recovered", 
                    "country", 
                    "state_id", 
                    "state",
                    "city_id",
                    "city") ]
  
  }
   
  #cache
 # if(cache)
 #   assign(cachekey, xxx, envir = cachedata)
  
  
  #' return
  return(xxx)

  }

