# Coronavirus COVID-19 (2019-nCoV) Data Acquisition and Visualization in R

![](https://www.r-pkg.org/badges/version/COVID19) ![](https://www.r-pkg.org/badges/last-release/COVID19) ![](https://cranlogs.r-pkg.org/badges/grand-total/COVID19) 

The R package aims at unifying COVID-19 datasets across different sources in order to simplify the data acquisition process and the subsequent analysis. The package implements advanced data visualization across the space and time dimensions by means of animated mapping to help and focus on making sense of the data.

COVID-19 data are pulled and merged with demographic indicators from several trusted sources including Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE); World Bank Open Data; World Factbook by CIA; Ministero della Salute, Dipartimento della Protezione Civile; Istituto Nazionale di Statistica; Swiss Federal Statistical Office.

For non R users, the datasets are made available in [csv format](https://storage.guidotti.dev/covid19/data/) (updated daily) or on [Kaggle](https://www.kaggle.com/eguidotti/coronavirus-covid19-2019ncov-epidemic-datasets/) (updated  weekly).

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

# Liechtenstein
l1 <- liechtenstein()        # by country

# US
u1 <- us("country")          # by country
u1 <- us("state")            # by state
```

## Data Visualization

```R
geomap(w1, 
  map = "world", 
  value = "confirmed",
  title = "COVID-19 Total Cases: {closest_state}",
  caption = "Data source: JHU CSSE")
```

![](https://storage.guidotti.dev/covid19/map/world.gif)

## Data Sources

|                      | deaths                                               | confirmed                                        | tests                                            | pop                                              | pop_14                                           | pop_15_64                                        | pop_65                                           | pop_age                                          | pop_density                               | pop_death_rate                            |
| -------------------- | ------------------------------------------------------------ | -------------------- | -------------------- | -------------------- | -------------------- | -------------------- | -------------------- | -------------------- | -------------------- | -------------------- |
| | number of COVID-19 deaths | number of COVID-19 confirmed cases | number of COVID-19 tests | total population | population ages 0-14 (% of total population)* | population ages 15-64 (% of total population)** | population ages 65+ (% of total population) | median age of population | population density per km$^2$ | population mortality rate |
| **World**            | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | [World Bank Open Data (2018)](https://data.worldbank.org/) | [World Bank Open Data (2018)](https://data.worldbank.org/) | [World Bank Open Data (2018)](https://data.worldbank.org/) | [World Bank Open Data (2018)](https://data.worldbank.org/) | [World Factbook by CIA (2018)](https://www.cia.gov/library/publications/resources/the-world-factbook/fields/343rank.html) | [World Bank Open Data (2018)](https://data.worldbank.org/) | [World Bank Open Data (2018)](https://data.worldbank.org/) |
| **US**            | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) | | | | | | |
| **Italy**            | [Ministero della Salute, Dipartimento della Protezione Civile](https://github.com/pcm-dpc/COVID-19) | [Ministero della Salute, Dipartimento della Protezione Civile](https://github.com/pcm-dpc/COVID-19) | [Ministero della Salute, Dipartimento della Protezione Civile](https://github.com/pcm-dpc/COVID-19) | [Istituto Nazionale di Statistica (2018)](https://www.istat.it/en/population-and-households?data-and-indicators) | [Istituto Nazionale di Statistica (2018)](https://www.istat.it/en/population-and-households?data-and-indicators) | [Istituto Nazionale di Statistica (2018)](https://www.istat.it/en/population-and-households?data-and-indicators) | [Istituto Nazionale di Statistica (2018)](https://www.istat.it/en/population-and-households?data-and-indicators) | [Istituto Nazionale di Statistica (2018)](https://www.istat.it/en/population-and-households?data-and-indicators) | [Istituto Nazionale di Statistica (2018)](https://www.istat.it/en/population-and-households?data-and-indicators) | [Istituto Nazionale di Statistica (2018)](https://www.istat.it/en/population-and-households?data-and-indicators) |
| **Switzerland**      | [Open Government Data by Swiss cantons](https://github.com/openZH/covid_19) | [Open Government Data by Swiss cantons](https://github.com/openZH/covid_19) | [Open Government Data by Swiss cantons](https://github.com/openZH/covid_19) | [Swiss Federal Statistical Office (2018)](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) | [Swiss Federal Statistical Office (2018)](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) | [Swiss Federal Statistical Office (2018)](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) | [Swiss Federal Statistical Office (2018)](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) | [Swiss Federal Statistical Office (2018)](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) | [Swiss Federal Statistical Office (2018)](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) | [Swiss Federal Statistical Office (2018)](https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html) |
| **Liechtenstein**    | [Open Government Data by Principality of Liechtenstein](https://github.com/openZH/covid_19) | [Open Government Data by Principality of Liechtenstein](https://github.com/openZH/covid_19) | [Open Government Data by Principality of Liechtenstein](https://github.com/openZH/covid_19) |                                                              |                                                              |                                                              |                                                              |                                                              |                                                              |                                                              |
| **Diamond Princess** | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19), [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_on_cruise_ships) | [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19), [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_on_cruise_ships) | [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_on_cruise_ships) | [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_on_cruise_ships) |  |  |  |  |  |  |

_* Switzerland: ages 0-19_

_** Switzerland: ages 20-64_

## Use Cases

- Monitoring the advancement of the COVID–19 contagion in the regions of Italy ([code](https://github.com/krzbar/COVID19))

