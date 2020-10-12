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

