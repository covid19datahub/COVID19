JPN <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # level
  if(level==1){
  
    # download
    x <- github.swsoyee.2019ncovjapan(cache = cache, level = level)
    
  }
  if(level==2){
    
    # download
    x <- github.swsoyee.2019ncovjapan(cache = cache, level = level)
    
    # id
    x$id <- id(x$jis_code, iso = "JPN", ds = "github.swsoyee.2019ncovjapan", level = level)
    
  }

  # return
  return(x)

}

