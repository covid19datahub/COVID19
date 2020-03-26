# COVID19

![](https://www.r-pkg.org/badges/version/COVID19) ![](https://www.r-pkg.org/badges/last-release/COVID19) ![](https://cranlogs.r-pkg.org/badges/grand-total/COVID19)

Up-to-date Coronavirus COVID-19 (2019-nCoV) Datasets from [Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)](https://github.com/CSSEGISandData/COVID-19) and [Ministero della Salute, Dipartimento della Protezione Civile, Italia](https://github.com/pcm-dpc/COVID-19).

## Quickstart

```R
# Install COVID19
devtools::install_github("emanuele-guidotti/COVID19") 

# Load COVID19
require('COVID19')
```
Download up-to-date tidy format datasets of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic. Pulled from the global dataset of [Johns Hopkins](https://github.com/CSSEGISandData/COVID-19) and the Italian dataset of [Ministero della Salute](https://github.com/pcm-dpc/COVID-19), the R package provides a summary of the coronavirus cases by country, region and city. The datasets contain various variables such as confirmed cases, deaths, and recovered.

```R
# Global data
w1 <- world()             # Historical data by country/state
w2 <- world(Sys.Date()-2) # Daily data by country/state

# Italian data
i1 <- italy()             # Data by country
i2 <- italy("region")     # Data by region
i3 <- italy("city")       # Data by city
```

![](https://storage.guidotti.dev/coronavirus/world/confirmed-total.gif)
