# Style Guide

COVID-19 Data Hub is developed around 2 concepts: 

- data sources
- countries  

To extract the data for one country, different data sources may be required. For this reason, it is important to keep the two concepts distinct. The code in the [R folder](https://github.com/covid19datahub/COVID19/tree/master/R) is organized in two main types of files:

- files representing a data source (prefix `ds_`)
- files representing a country (prefix `iso_`)

The R comments prefixed with `#'` are used to generate the documentation with [roxygen2](https://roxygen2.r-lib.org/). The comments prefixed with `#` are not used to generate the documentation. The package is set up to support the usage of Rmarkdown syntax in the docstring. Each documentation block (`#'`) starts uppercase and ends with a blank line. Each non-documentation comment (`#`) does not include the blank line and starts lowercase. 

```R
#' This is a documentation block
#'
code here...

# this is a comment not used in the documentation
code here...
```

## `ds_` files

### Naming convention

The `ds_` files are named according to the domain of the website where the data are provided (e.g. `example.com`). No subdomain is included (e.g., `sub.example.com` becomes `example.com`). For instance, if the data are pulled from https://coronavirus.data.gov.uk/details/developers-guide the file will be named `ds_gov.uk.R`. 

For GitHub repositories, we use `github.username.repository` (lowercase). Hyphens and dashes are dropped. For instance https://github.com/CSSEGISandData/COVID-19 becomes `ds_github.cssegisanddata.covid19.R`

For open data sharing portals, such as https://www.arcgis.com, we use the domain of the portal with the suffix corresponding to the [Alpha-2 ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) code of the country providing the data. For example, the Swedish Public Health Agency is proving the data at https://www.arcgis.com/home/item.html?id=b5e7488e117749c19881cce45db13f7e which becomes `ds_arcgis.se.R` (`SE` being the 2 letter ISO code for Sweden).

### Code style

A `ds_` file implements the R function responsible to download the data from the provider and format them in a `data.frame` with the column `date` (mandatory) and the columns below (optional). The order is irrelevant and not all the columns need to be provided. Additional columns may be included.

| Variable                  | Description                                                  |
| ------------------------- | ------------------------------------------------------------ |
| `confirmed`               | Cumulative number of confirmed cases.                        |
| `deaths`                  | Cumulative number of deaths.                                 |
| `recovered`               | Cumulative number of patients reported recovered.            |
| `tests`                   | Cumulative number of tests.                                  |
| `vaccines`                | Cumulative number of total vaccine doses administered.       |
| `people_vaccinated`       | Cumulative number of people who received at least one vaccine dose. |
| `people_fully_vaccinated` | Cumulative number of people who received all doses prescribed by the vaccination protocol. |
| `hosp`                    | Number of hospitalized patients on date.                     |
| `icu`                     | Number of hospitalized patients in ICUs on date.             |
| `vent`                    | Number of patients requiring invasive ventilation on date.   |

The function takes the argument `level` as input. It may implement additional arguments as well. The function starts with an `if` condition to make clear which `level` is supported. The function has the same name of the corresponding `ds_` file (without the prefix `ds_` and without the suffix `.R`). 

```R
github.eguidotti.covid19br <- function(level){
  if(level!=3) return(NULL)
    
  # code here...
    
}
```

### Documentation style

The documentation starts with the name of the data provider. The name of the data provider is:

- the official name of organizations (preferably in English)
- the name of individuals (e.g., for personal GitHub repositories)

```R
#' Wesley Cota
#'
github.wcota.covid19br <- function(level){
```

The description is "Data source for:" followed by the name of the country for which the data are provided. This is a comma-separated list of countries if multiple countries are supported. Use "Worldwide" if this is a worldwide data source.

```R
#' Wesley Cota
#'
#' Data source for: Brazil
#'
github.wcota.covid19br <- function(level){
```

The rest of the documentation block is generated with the function `ds_docstring` from this package (copy-paste its output in the file).

### Complete example

- File name `ds_github.wcota.covid19br.R`

```R
#' Wesley Cota
#'
#' Data source for: Brazil
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#'
#' @source https://github.com/wcota/covid19br
#'
#' @keywords internal
#' 
github.wcota.covid19br <- function(level){
  if(!level %in% 1:3) return(NULL)

  # code here...

  return(x)  
}
```

## `iso_` files

### Naming convention

The `iso_` files are named according to the [Alpha-3 ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) code of the country. For instance, the file for United States is named `iso_USA.R` (`USA` being the 3 letter ISO code for United States).

### Code style

An `iso_` file implements the R function responsible to aggregate all the data sources for the country. The function is named with the three letter ISO code of the country. The function takes the argument `level` in input as well as `...` for backward compatibility. For example, for Brazil we have:

```R
BRA <- function(level, ...){
  # code here...   
}
```

The function defines the internal variable `x` that represents the output of the function. This is the very first line of code in the body of the function. The very last line of code returns `x`. 

```R
BRA <- function(level, ...){
  x <- NULL
  
  # code here...   
  
  return(x)
}
```

Internally, the code is split by `level`, with no white spaces in the `if` condition and one blank line among different lines. Not all the 3 levels are required.

```R
BRA <- function(level, ...){
  x <- NULL
  
  if(level==1){
      
    # code here...         
      
  }

  if(level==2){
      
    # code here...         
      
  }
    
  return(x)
}
```

### Documentation style

The documentation starts with the name of the country and with the link to the file in this repository that implements the country. The link is generated with the function `repo` that takes as input the name of the function as follows:

```R
#' Brazil 
#'
#' @source \url{`r repo("BRA")`}
#' 
BRA <- function(level, ...){
```

For each level we create a new @concept and a new subsection in the "Data Sources" @section. The `docstring` function automatically generates the documentation for the providers of population data.

```R
#' Brazil 
#'
#' @source \url{`r repo("BRA")`}
#' 
BRA <- function(level, ...){
  x <- NULL
  
  #' @concept level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("BRA", 1)`
  #'  
  if(level==1){
```

For each data source, we report the link to the `ds_` function, the name of the data provider, and the list of variables available. The documentation block is generated with the function `iso_docstring` from this package (copy-paste its output in the file).

```R
#' Brazil 
#'
#' @source \url{`r repo("BRA")`}
#' 
BRA <- function(level, ...){
  x <- NULL
  
  #' @concept level 1
  #' @section Data Sources:
  #'
  #' ## Level 1
  #' `r docstring("BRA", 1)`
  #'
  if(level==1){
    
    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered.
    #'
    x <- github.wcota.covid19br(level = level)
```

### Complete example

- File name: `iso_BRA.R`

```R
#' Brazil 
#'
#' @source \url{`r repo("BRA")`}
#' 
BRA <- function(level, ...){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("BRA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered.
    #'
    x <- github.wcota.covid19br(level = level)
   
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("BRA", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered.
    #'
    x <- github.wcota.covid19br(level = level)
    x$id <- id(x$state, iso = "BRA", ds = "github.wcota.covid19br", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("BRA", 3)`
  #' 
  if(level==3){  

    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- github.wcota.covid19br(level = level)
    x$id <- id(x$code, iso = "BRA", ds = "github.wcota.covid19br", level = level)
    
    #' - \href{`r repo("github.eguidotti.covid19br")`}{Emanuele Guidotti}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    v <- github.eguidotti.covid19br(level = level)
    v$id <- id(v$ibge, iso = "BRA", ds = "github.eguidotti.covid19br", level = level)
    
    # merge
    x <- dplyr::left_join(x, v, by = c("id", "date"))
    
  }
  
  return(x)
}
```



