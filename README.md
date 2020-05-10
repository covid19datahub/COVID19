<a href="https://covid19datahub.io"><img src="https://storage.covid19datahub.io/logo.svg" align="right" height="128"/></a>

# COVID-19 Data Hub

![](https://www.r-pkg.org/badges/version/COVID19) ![](https://www.r-pkg.org/badges/last-release/COVID19) ![](https://cranlogs.r-pkg.org/badges/grand-total/COVID19) [![](https://img.shields.io/badge/doi-10.13140/RG.2.2.11649.81763-orange.svg)](https://doi.org/10.13140/RG.2.2.11649.81763)

The repository aims at unifying COVID-19 datasets across different sources in order to simplify the data acquisition process and the subsequent analysis. __You are welcome to join__ and extend the number of supporting data sources as a joint effort against COVID-19. Join us on [Slack](https://join.slack.com/t/covid19datahub/shared_invite/zt-dld2grt2-vmso7HkI8yFabW5R_mAZJw) to get help, contribute and earn a [badge](https://eu.badgr.com/public/badges/MC89IAjTTLGs3geP3xHjRw). 

## Quickstart

```R
# Install COVID19
remotes::install_github("covid19datahub.io/COVID19dev")

# Load COVID19
require("COVID19dev")
```
## Implement a new data source

- Get inspired by the `ds_*` files [here](<https://github.com/covid19datahub/COVID19dev/tree/master/R>).

- Create a new `ds_*` file named with the domain of the data source (lowercase and replace `.` with `_`). The function should return a `data.frame` with the columns `date` (date object), `tests` (cumulative number of tests), `confirmed` (cumulative number of confirmed cases), `deaths` (cumulative number of deaths), `recovered` (cumulative number of recovered), `hosp` (hospitalized on date), `vent` (requiring ventilation on date), `icu` (intensive therapy on date). Only the column `date` is strictly required, additional columns may be included as well.
- Open a [new issue](<https://github.com/covid19datahub/COVID19dev/issues>) and submit your function (attach the R file). Thanks!

## Documentation

<https://storage.covid19datahub.io/doc/COVID19.pdf>

## Reference

Guidotti, E., Ardia, D., (2020).      
_COVID-19 Data Hub_       
Working paper   
[https://doi.org/10.13140/RG.2.2.11649.81763](https://doi.org/10.13140/RG.2.2.11649.81763)  