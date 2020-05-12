### Find the data

##### Which data-sources are eligible?

- Level 1: Official, complete, fast-updating. 
- Level 2: Official, complete, fast-updating. If missing, well-documented and well-structured sources are temporary good 
- Level 3: We prioritize Official, complete, fast-updating data. If missing well-documented and well-structured sources are good.

To have a better idea, check out the [sources](https://github.com/covid19datahub/COVID19dev/tree/master/R) that have already been implemented.

##### How to find an eligible data-source?

- Check our list [of data-sources](https://github.com/covid19datahub/COVID19/blob/master/TODO.md) that have yet to be integrated 

- Look for a new data-source! Check out these [suggestions](https://covid19datahub.slack.com/archives/C012XQVAQ2W) on where to start looking.

  

### Write the function

Create a new `ds_*` file, named with the domain of the data source, that does the followings:

- **Load** the COVID19 and (if any) other required packages

- **Download** the data and store it in a variable called  `x`

  ```R
  repo <- "https://raw.githubusercontent.com/opencovid19-fr"
  url  <- "/data/master/dist/chiffres-cles.csv"
  x    <- read.csv(paste0(repo,url), cache = cache) 
  ```

- **Rename** the columns according to our [format](https://covid19datahub.io/articles/doc/data.html): 

- `date` (date object)

  - `tests` (cumulative number of tests)
  - `confirmed` (cumulative number of confirmed cases)
  - `deaths` (cumulative number of deaths)
  - `recovered` (cumulative number of recovered)
  - `hosp` (hospitalized on date)
  - `vent` (requiring ventilation on date)
  - `icu` (intensive therapy on date). 

  Remember that only the column `date` is required, all the others could be dropped if the data is missing

  ```R
  x <- map_data(x, c(
    'date',
    'depistes'      = 'tests',
    'cas_confirmes' = 'confirmed',
    'deces'         = 'deaths',
    'gueris'        = 'recovered',
    'hospitalises'  = 'hosp',
    'reanimation'   = 'icu',
    'granularite',
    'maille_code',
    'maille_nom'
  ))
  ```

- **Format** the data correctly. Most importantly, `date` should be of the format date.

  ``` 
  x$date <- as.Date(x$date)
  ```

- **Clean** your data! This could include operation such as:

  - Imposing NAs on values different than NA and numeric
  - Dropping non-useful columns
  - Fixing encoding issues
  - ...

  ```R
  x <- x %>% 
    distinct(date, maille_code, .keep_all = TRUE)
  ```

  

- **Filter** your data, based on the function input `level`*(Required only if your data contains more than one level)*

  ```R
  if(level==1)
    x<- x[x$granularite=="pays",]  
  if(level==2)
    x<- x[x$granularite %in% c("region", "collectivite-outremer"),]
  if(level==3)
    x<- x[x$granularite=="departement",]
  ```

- **Return** the result

Remember that your function must have the parameter `cache` as a first element, and the others (`level`, ...) could be in random order.

The utilities that you can find [here](https://covid19datahub.io/reference/) could be very useful!



### Test the function and the data

In order to test if your function is working, try answering the following questions.

- Is the function returning a data-frame with correct column names?
- Is the data coherent with the original source?
- Is the data coherent with other sources? *(fast trick, google COVID19 + iso)*
- Is the function working properly with all the possible levels?
