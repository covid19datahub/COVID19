# COVID19 2.3.1 (2021-09-25)

## Minor Changes

- Added standardized geospatial IDs (`foreign_key` and `foreign_key_type`), e.g., FIPS codes for United States and NUTS codes for Europe.

## Data Update

- Added data for Belgium (level 3).
- Change data provider for Switzerland and Liechtenstein to [Federal Office of Public Health FOPH](https://www.covid19.admin.ch) 

# COVID19 2.3.0 (2021-04-01)

## Breaking Changes

- Due to the incresing size of the data files, we will stop to provide the [pre-processed data](https://covid19datahub.io/articles/data.html) on 01 April 2021, so to improve the update and storage of the raw data. Please switch to the raw data if you are still using the pre-processed files.

# COVID19 2.3.0 (2021-03-03)

## Data Update

- Canadian data level 2: https://health-infobase.canada.ca/covid-19/ has changed the way of reporting `tests`. This is creating a spike in the data but will reflect the change in the official data provider. See issue [#156](https://github.com/covid19datahub/COVID19/issues/156)

> Starting February 1, 2021, laboratory test indicators are based on the number of laboratory tests performed and the percentage of tests positive. These data replace previous metrics based on unique individuals tested and provide a more accurate measure of test positivity and promote greater standardization in reporting across Canada. The proportion of tests positive is expected to decrease compared with previous person-based methods, as all tests will be included in the calculation, including new tests on the same person over time.

# COVID19 2.3.0 (2021-03-01)

## Data Update

- State-level data for US have changed data provider(s) due to the shutdown of the [COVID Tracking Project](https://covidtracking.com/analysis-updates/covid-tracking-project-end-march-7). Tests are now from the [Department of Health & Human Services](https://healthdata.gov/dataset/covid-19-diagnostic-laboratory-testing-pcr-testing-time-series). Hospitalized and ICU are now from [Department of Health & Human Services](https://healthdata.gov/dataset/covid-19-reported-patient-impact-and-hospital-capacity-state). Confirmed cases and fatalities are now from [The New York Times](https://github.com/nytimes/covid-19-data). Data at national and county level have not been affected.

- Added data for Brazil (levels 2 and 3) from [this awesome repository](https://github.com/wcota/covid19br/) and vaccines from the [Ministry of Health of Brazil](https://opendatasus.saude.gov.br/dataset/covid-19-vacinacao) 


# COVID19 2.3.0 (2021-01-02)

## Data Update

* Added number of people who have been **vaccinated** for level 1. Data pulled from [Our World in Data](https://ourworldindata.org/covid-vaccinations).

# COVID19 2.3.0 (2020-12-12)

## Data Update

* **US policies** for admin areas level 3 (counties) are now inherited from the policies available for admin areas level 2 (states) instead of level 1 (nation). 

# COVID19 2.3.0 (2020-11-30)

## Data Update

* **Colombia data**. Fixed `deaths` and `confirmed` according to https://coronaviruscolombia.gov.co Added `tests` for level 1 and 2

# COVID19 2.3.0 (2020-10-30)

## Data Update

* **Austria data**. Added support for level 2 and 3 from the [Federal Ministry of Social Affairs, Health, Care and Consumer Protection](https://covid19-dashboard.ages.at/dashboard.html)

# COVID19 2.3.0 (2020-10-28)

## Data Update

* **Policy measures**. Added support for level 2 policies by [Oxford Covid-19 Government Response Tracker](https://github.com/OxCGRT/covid-policy-tracker). Enhanced policy inheritance by using [OxCGRT flags](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md) to distinguish policies that are "targeted" to a specific geographical region (flag=0) or "general" policies that are applied across the whole country (flag=1). Only "general" policies are propagated to levels 2 and 3.

# COVID19 2.3.0 (2020-10-27)

## Data Update

* **Netherlands data** all levels. Change data provider from [JHU CSSE](https://github.com/CSSEGISandData/COVID-19) to [National Institute for Public Health and the Environment of Netherlands](https://data.rivm.nl/covid-19/). Affected variables: `confirmed`, `deaths`, `hosp`.

# COVID19 2.3.0 (2020-10-12)

## Data Update

* **Swiss data** level 1. Change data provider from [JHU CSSE](https://github.com/CSSEGISandData/COVID-19) to [Federal Office of Public Health FOPH](https://www.bag.admin.ch/bag/en/home/krankheiten/ausbrueche-epidemien-pandemien/aktuelle-ausbrueche-epidemien/novel-cov/situation-schweiz-und-international.html). Affected variables: `confirmed`, `deaths`, `hosp`.
	
# COVID19 2.3.0 (2020-09-20)

## Data Update

* Added data for:
	
	- Chile: level 1, 2, and 3 (`confirmed`, `tests`, `deaths`, `recovered`, `hosp`, `icu`, `population`)
	- Taiwan: level 1 and 2 (`confirmed`, `latitude`, `longitude`, `population`)
	
# COVID19 2.3.0 (2020-09-20)

## Data Update

* Added data for:
	
	- Thailand: level 1 and 2 (`confirmed`, `deaths`, `recovered`, `hosp`)
	- Ireland: level 1 and 2 (`tests`, `confirmed`, `deaths`, `hosp`, `icu`)
	
# COVID19 2.3.0 (2020-09-05)

## Data Update

* Added data for:
	
	- Poland: level 2 and 3 (`deaths`)
	- Croatia: level 2 (`confirmed`, `deaths`)
	
# COVID19 2.3.0 (2020-08-28)

## Minor changes

* **R and Python** packages now return raw data by default.

# COVID19 2.2.0 (2020-08-17)

## Minor changes

* **UK data** (all levels). Change the access to https://coronavirus.data.gov.uk from the [legacy CSV downloads](https://coronavirus.data.gov.uk/about-data) to the new [API](https://coronavirus.data.gov.uk/developers-guide).

# COVID19 2.2.0 (2020-07-17)

## Major changes

* drop `severe` cases (equivalent to `icu`)

# COVID19 2.0.0 (2020-06-21)

## Major changes

* **US data** level 3 (counties). Change data provider from [JHU CSSE](https://github.com/CSSEGISandData/COVID-19) to [New York Times](https://github.com/nytimes/covid-19-data). Only minor counties not provided by [New York Times](https://github.com/nytimes/covid-19-data) are still from [JHU CSSE](https://github.com/CSSEGISandData/COVID-19).

