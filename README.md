<a href="https://covid19datahub.io"><img src="https://storage.covid19datahub.io/logo.svg" align="right" height="128"/></a>

# Coronavirus COVID-19 (2019-nCoV) Epidemic Datasets

![](https://www.r-pkg.org/badges/version/COVID19) ![](https://www.r-pkg.org/badges/last-release/COVID19) ![](https://cranlogs.r-pkg.org/badges/grand-total/COVID19) [![](https://img.shields.io/badge/doi-10.13140/RG.2.2.11649.81763-orange.svg)](https://doi.org/10.13140/RG.2.2.11649.81763)

The repository aims at unifying COVID-19 datasets across different sources in order to simplify the data acquisition process and the subsequent analysis. __You are welcome to join__ and [contribute](https://github.com/covid19datahub/COVID19/blob/master/CONTRIBUTING.md) by extending the number of supporting data sources as a joint effort against COVID-19.

The data are available to the end-user via the [R package COVID19](https://cran.r-project.org/package=COVID19) or in csv format (see [below](https://github.com/covid19datahub/COVID19#csv-data-files) or on [Kaggle](https://www.kaggle.com/eguidotti/coronavirus-covid19-2019ncov-epidemic-datasets/)).

## About

### Goal

Provide the research community with a unified data hub by collecting worldwide fine-grained data merged with demographics, air pollution, and other exogenous variables helpful for a better understanding of COVID-19.

### How 

The data are collected with the [R package COVID19](https://cran.r-project.org/package=COVID19). For R users, the COVID19 package is the recommended way to interact with the dataset. For non R users, the data are provided in csv format and regularly updated (see [below](https://github.com/covid19datahub/COVID19#csv-data-files) or on [Kaggle](https://www.kaggle.com/eguidotti/coronavirus-covid19-2019ncov-epidemic-datasets/)).

### Join the mission

Whether or not you are an R user... take part in the data collection!

- See [how to contribute](https://github.com/covid19datahub/COVID19/blob/master/CONTRIBUTING.md) to get started
- Join us on [Slack](https://join.slack.com/t/covid19datahub/shared_invite/zt-dld2grt2-vmso7HkI8yFabW5R_mAZJw) to get help
- Submit your pull request and earn a [badge](https://eu.badgr.com/public/badges/MC89IAjTTLGs3geP3xHjRw)

## R Package COVID19

Simple, yet effective R package to acquire tidy format datasets of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic. The data are downloaded in real-time, cleaned and matched with exogenous variables.

### Quickstart

```R
# Install COVID19
install.packages("COVID19")

# Load COVID19
require("COVID19")
```
### Usage

```R
covid19(ISO = NULL, level = 1, start = "2019-01-01", end = Sys.Date(), vintage = FALSE, raw = FALSE, cache = TRUE)
```

### Arguments

| Argument    | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| ```ISO```   | vector of ISO codes to retrieve (alpha-2, alpha-3 or numeric). Each country is identified by one of its [ISO codes](https://github.com/covid19datahub/COVID19/blob/master/inst/extdata/db/ISO.csv) |
| ```level``` | integer. Granularity level. 1: country-level data. 2: state-level data. 3: city-level data. |
| `start`     | the start date of the period of interest.                    |
| `end`       | the end date of the period of interest.                      |
| `vintage`   | logical. Retrieve the snapshot of the dataset at the `end` date instead of using the latest version? Default `FALSE`. |
| ```raw```   | logical. Skip data cleaning? Default `FALSE`.                |
| ```cache``` | logical. Memory caching? Significantly improves performance on successive calls. Default `TRUE`. |

### Details

The raw data are cleaned by filling missing dates with `NA` values. This ensures that all countries share the same grid of dates and no single day is skipped. Then, `NA` values are replaced with the previous non-`NA` value or `0`.

If no data is available at a granularity level (country/state) but is available at a lower level (state/city), the higher level data are obtained by aggregating the lower level data.

### Examples

```R
# Worldwide data by country
covid19()

# Worldwide data by state
covid19(level = 2)

# US data by state
covid19("USA", level = 2)

# Swiss data by state (cantons)
covid19("CHE", level = 2)

# Italian data by state (regions)
covid19("ITA", level = 2)

# Italian and US data by city
covid19(c("ITA","USA"), level = 3)
```

### Cite the Data Sources

```r
# Cite the data sources 
x   <- covid19()
cit <- covid19cite(x)
View(cit)
```

## Dataset

| Variable                              | Description                                                  |
| ------------------------------------- | ------------------------------------------------------------ |
| `id`                                  | Location identifier.                                         |
| `date`                                | Observation time.                                            |
| `deaths`                              | Cumulative number of  deaths.                                |
| `confirmed`                           | Cumulative number of  confirmed cases.                       |
| `tests`                               | Cumulative number of  tests.                                 |
| `recovered`                           | Cumulative number of patients released from hospitals or reported recovered. |
| `hosp`                                | Number of hospitalized patients on date.                     |
| `icu`                                 | Number of hospitalized patients in ICUs on date.             |
| `vent`                                | Number of patients requiring invasive ventilation on date.   |
| `school_closing`                      | 0: No measures - 1: Recommend closing - 2: Require closing (only some levels or categories, eg just high school, or just public schools - 3: Require closing all levels. [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `workplace_closing`                   | 0: No measures - 1: Recommend closing (or work from home) - 2: require closing for some sectors or categories of workers - 3: require closing (or work from home) all-but-essential workplaces (eg grocery stores, doctors). [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `cancel_events`                       | 0: No measures - 1: Recommend cancelling - 2: Require cancelling. [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `gatherings_restrictions`             | 0: No restrictions - 1: Restrictions on very large gatherings (the limit is above 1000 people) - 2: Restrictions on gatherings between 100-1000 people - 3: Restrictions on gatherings between 10-100 people - 4: Restrictions on gatherings of less than 10 people. [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `transport_closing`                   | 0: No measures - 1: Recommend closing (or significantly reduce volume/route/means of transport available) - 2: Require closing (or prohibit most citizens from using it). [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `stay_home_restrictions`              | 0: No measures - 1: recommend not leaving house - 2: require not leaving house with exceptions for daily exercise, grocery shopping, and "essential" trips - 3: Require not leaving house with minimal exceptions (e.g. allowed to leave only once every few days, or only one person can leave at a time, etc.). [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `internal_movement_restrictions`      | 0: No measures - 1: Recommend closing (or significantly reduce volume/route/means of transport) - 2: Require closing (or prohibit most people from using it). [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `international_movement_restrictions` | 0: No measures - 1: Screening - 2: Quarantine arrivals from high-risk regions - 3: Ban on high-risk regions - 4: Total border closure. [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `information_campaigns`               | 0: No COVID-19 public information campaign - 1: public officials urging caution about COVID-19 - 2: coordinated public information campaign (e.g. across traditional and social media). [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `testing_policy`                      | 0: No testing policy - 1: Only those who both (a) have symptoms AND (b) meet specific criteria (eg key workers, admitted to hospital, came into contact with a known case, returned from overseas) - 2: testing of anyone showing COVID-19 symptoms - 3: open public testing (eg  "drive through" testing available to asymptomatic people). [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `contact_tracing`                     | 0: No contact tracing - 1: Limited contact tracing, not done for all cases - 2: Comprehensive contact tracing, done for all cases. [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `stringency_index`                    | Stringency of governmental responses. [More details](https://www.bsg.ox.ac.uk/sites/default/files/2020-04/BSG-WP-2020-032-v5.0.pdf) |
| `mkt_close`                           | Stock market price (Close).                                  |
| `mkt_volume`                          | Stock market volume.                                         |
| `country`                             | Administrative area of top level.                            |
| `state`                               | Administrative area of a lower level, usually states, regions or cantons. |
| `city`                                | Administrative are of a lower level, usually cities or municipalities. |
| `lat`                                 | Latitude.                                                    |
| `lng`                                 | Longitude.                                                   |
| `pop`                                 | Total population.                                            |
| `pop_female`                          | Population, female (% of total population).                  |
| `pop_14`                              | Population ages 0-14 (% of total population)<sup>*</sup>.    |
| `pop_15_64`                           | Population ages 15-64 (% of total population).<sup>**</sup>  |
| `pop_65`                              | Population ages 65+ (% of total population).                 |
| `pop_age`                             | Median age of population.                                    |
| `pop_density`                         | Population density per km<sup>2</sup>.                       |
| `pop_death_rate`                      | Population mortality rate.                                   |
| `hosp_beds`                           | Hospital beds (per 1,000 people).                            |
| `smoking_male`                        | Smoking prevalence, males (% of adults).                     |
| `smoking_female`                      | Smoking prevalence, females (% of adults).                   |
| `gdp`                                 | Gross Domestic Product (US$).                                |
| `health_exp`                          | Current health expenditure (% of GDP).                       |
| `health_exp_oop`                      | Out-of-pocket expenditure (% of health expenditure).         |

<sup>*</sup> _Switzerland: ages 0-19_

<sup>**</sup> _Switzerland: ages 20-64_

## CSV Data Files

CSV datasets generated with the [R package COVID19](https://cran.r-project.org/package=COVID19) and updated daily. 

__Clean data__

- <https://storage.covid19datahub.io/data-1.csv> (admin area level 1)
- <https://storage.covid19datahub.io/data-2.csv> (admin area level 2)
- <https://storage.covid19datahub.io/data-3.csv> (admin area level 3)

__Raw data__

- <https://storage.covid19datahub.io/rawdata-1.csv> (admin area level 1)
- <https://storage.covid19datahub.io/rawdata-2.csv> (admin area level 2)
- <https://storage.covid19datahub.io/rawdata-3.csv> (admin area level 3)

## Data coverage 

The following data are included in the COVID-19 Data Hub.

- https://storage.covid19datahub.io/coverage.html

## Data sources 

The following sources are gratefully acknowledged for making the data available to the public.

- https://github.com/covid19datahub/COVID19/tree/master/inst/extdata/db/_src.csv

### Acknowledgements 

The following people have contributed to the data collection as a joint effort against COVID-19.

- https://github.com/covid19datahub/COVID19/graphs/contributors

## Use Cases

Using the COVID-19 Data Hub? Open an [issue](https://github.com/covid19datahub/COVID19/issues) and let us know about your project!

- [Brazilian COVID-19 Dashboard](https://app.powerbi.com/view?r=eyJrIjoiNWExN2JlMzQtNTBiOC00ODU5LWIxY2QtODQwZTNhMjQzNGJmIiwidCI6ImMzN2IzN2EzLWU5ZTItNDJmOS1iYzY3LTRiOWI3MzhlMWRmMCJ9)
- [Monitoring the advancement of the COVID–19 contagion in the regions of Italy](https://github.com/krzbar/COVID19)
- [Covid19 Incidence History](http://emit.phys.ocean.dal.ca/~kelley/covid19/)

## Terms of Use and Disclaimer

We have invested a lot of time and effort in creating [COVID-19 Data Hub](https://covid19datahub.io/). We expect you to agree to the following rules when using it: 

1. cite [Guidotti and Ardia (2020)](https://doi.org/10.13140/RG.2.2.11649.81763) in working papers and published papers that use [COVID-19 Data Hub](https://covid19datahub.io/)
2. place the URL [https://covid19datahub.io](https://covid19datahub.io) in a footnote to help others find [COVID-19 Data Hub](https://covid19datahub.io/) 
3. you assume full risk for the use of [COVID-19 Data Hub](https://covid19datahub.io/).

The [COVID-19 Data Hub](https://covid19datahub.io/) (R package COVID19, GitHub repo, cloud storage), and its contents herein, including all data, mapping, and analyses, are provided to the public strictly for educational and academic research purposes. The [COVID-19 Data Hub](https://covid19datahub.io/) relies upon publicly available data from multiple sources. We are currently in the process of reconciling the providers with proper reference to their open-source data. Please inform us if you see any issues with the data licenses.

We try our best to guarantee the data quality and consistency and the continuous filling of the [COVID-19 Data Hub](https://covid19datahub.io/). However, it is free software and comes with ABSOLUTELY NO WARRANTY. We hereby disclaim any and all representations and warranties with respect to the [COVID-19 Data Hub](https://covid19datahub.io/), including accuracy, fitness for use, and merchantability. Reliance on the [COVID-19 Data Hub](https://covid19datahub.io/) for medical guidance or use of the [COVID-19 Data Hub](https://covid19datahub.io/) in commerce is strictly prohibited. 

## Reference

Guidotti, E., Ardia, D., (2020).      
_COVID-19 Data Hub_       
Working paper   
[https://doi.org/10.13140/RG.2.2.11649.81763](https://doi.org/10.13140/RG.2.2.11649.81763)  
