# Coronavirus COVID-19 (2019-nCoV) Data Acquisition and Visualization

![](https://www.r-pkg.org/badges/version/COVID19) ![](https://www.r-pkg.org/badges/last-release/COVID19) ![](https://cranlogs.r-pkg.org/badges/grand-total/COVID19) 

Pre-processed, ready-to-use, tidy format datasets of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic. The latest data are downloaded in real-time, processed and merged with demographic indicators from several trusted sources. The package implements advanced data visualization across the space and time dimensions by means of animated mapping. Besides worldwide data, the package includes granular data for Italy, Switzerland and the Diamond Princess.

| field          | description                                   |
| -------------- | --------------------------------------------- |
| id             | id in the form "country\|state\|city"         |
| date           | date                                          |
| country        | administrative area level 1                   |
| state          | administrative area level 2                   |
| city           | administrative area level 3                   |
| lat            | latitude                                      |
| lng            | longitude                                     |
| deaths         | the number of deaths                          |
| confirmed      | the number of cases                           |
| tests          | the number of tests                           |
| deaths_new     | daily increase in the number of deaths        |
| confirmed_new  | daily increase in the number of cases         |
| tests_new      | daily increase in the number of tests         |
| pop            | total population                              |
| pop_14         | population ages 0-14 (% of total population)  |
| pop_15_64      | population ages 15-64 (% of total population) |
| pop_65         | population ages 65+ (% of total population)   |
| pop_age        | median age of population                      |
| pop_density    | population density per km2                    |
| pop_death_rate | population mortality rate                     |

## Quickstart

```R
# Install COVID19
install.packages("COVID19")

# Load COVID19
require("COVID19")
```
## Data Acquisition

```R
# Diamond Princess
d1 <- diamond()

# Global data
w1 <- world("country")       # by country
w2 <- world("state")         # by state

# Swiss data
s1 <- switzerland("country") # by country
s2 <- switzerland("state")   # by canton

# Italian data
i1 <- italy("country")       # by country 
i2 <- italy("state")         # by region 
i3 <- italy("city")          # by city
```

## Data Visualization

```R
geomap(w2, 
  map = "world", 
  value = "confirmed_new",
  legend.title = "Daily Cases",
  caption = "Data source: JHU CSSE",
  nframes = 30+(2*length(unique(w2$date))),
  end_pause = 30)
```

![](https://storage.guidotti.dev/coronavirus/world/confirmed-new.gif)

## Data Sources

|                      | COVID-19                                                     | Demographics                                                 |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **World**            | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | [World Bank Open Data](https://data.worldbank.org/), [World Factbook by CIA](https://www.cia.gov/library/publications/resources/the-world-factbook/fields/343rank.html). |
| **Italy**            | [Ministero della Salute, Dipartimento della Protezione Civile](https://github.com/pcm-dpc/COVID-19) | [Istituto Nazionale di Statistica](https://www.istat.it/en/population-and-households?data-and-indicators) |
| **Switzerland**      | [Repository collecting the data published on the cantonal websites](https://github.com/daenuprobst/covid19-cases-switzerland) | [Swiss Federal Statistical Office](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) |
| **Diamond Princess** | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19), [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_on_cruise_ships) | [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_on_cruise_ships) |