# Coronavirus COVID-19 (2019-nCoV) Data Acquisition and Visualization in R

![](https://www.r-pkg.org/badges/version/COVID19) ![](https://www.r-pkg.org/badges/last-release/COVID19) ![](https://cranlogs.r-pkg.org/badges/grand-total/COVID19) 

The R package aims at unifying COVID-19 datasets across different sources in order to simplify the data acquisition process and the subsequent analysis. The package implements advanced data visualization across the space and time dimensions by means of animated mapping to help and focus on making sense of the data.

COVID-19 data are pulled and merged with demographic indicators from several trusted sources including Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE); World Bank Open Data; World Factbook by CIA; Ministero della Salute, Dipartimento della Protezione Civile; Istituto Nazionale di Statistica; Swiss Federal Statistical Office.

For non R users, the datasets are made available in [csv format](https://storage.guidotti.dev/covid19/data/) (updated daily) or on [Kaggle](https://www.kaggle.com/eguidotti/coronavirus-covid19-2019ncov-epidemic-datasets/) (updated  weekly).

## Quickstart

```R
# Install COVID19
devtools::install_github("emanuele-guidotti/COVID19")

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

![](https://storage.guidotti.dev/covid19/map/world.gif)

## Data Sources

|                      | COVID-19                                                     | Demographics                                                 |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **World**            | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | [World Bank Open Data](https://data.worldbank.org/), [World Factbook by CIA](https://www.cia.gov/library/publications/resources/the-world-factbook/fields/343rank.html). |
| **Italy**            | [Ministero della Salute, Dipartimento della Protezione Civile](https://github.com/pcm-dpc/COVID-19) | [Istituto Nazionale di Statistica](https://www.istat.it/en/population-and-households?data-and-indicators) |
| **Switzerland**      | [Repository collecting the data published on the cantonal websites](https://github.com/daenuprobst/covid19-cases-switzerland) | [Swiss Federal Statistical Office](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) |
| **Diamond Princess** | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19), [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_on_cruise_ships) | [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_on_cruise_ships) |

