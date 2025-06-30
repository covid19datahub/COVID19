<a href="https://covid19datahub.io"><img src="https://storage.covid19datahub.io/logo.svg" align="right" height="128"/></a>

# COVID-19 Data Hub [![Twitter URL](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2Fcovid19datahub%2FCOVID19%2F)](https://twitter.com/intent/tweet?url=https%3A%2F%2Fgithub.com%2Fcovid19datahub%2FCOVID19)

[![](https://storage.covid19datahub.io/downloads/total.svg)](https://covid19datahub.io/articles/data.html) 

> Funded by the Institute for Data Valorization [IVADO](https://ivado.ca/en/) in 2020. Supported by the [R Consortium](https://www.r-consortium.org) from 2021 to 2024. Funded by the University of Lugano [USI](https://www.usi.ch/en) in 2025.

This repository aggregates COVID-19 data at a fine-grained spatial resolution from [several sources](https://covid19datahub.io/reference/index.html) and makes them available in the form of ready-to-use CSV files available at https://covid19datahub.io

| Variable                  | Description                                                  |
| ------------------------- | ------------------------------------------------------------ |
| `confirmed`               | Cumulative number of confirmed cases                         |
| `deaths`                  | Cumulative number of deaths                                  |
| `recovered`               | Cumulative number of patients released from hospitals or reported recovered |
| `tests`                   | Cumulative number of tests                                   |
| `vaccines`                | Cumulative number of total doses administered                |
| `people_vaccinated`       | Cumulative number of people who received at least one vaccine dose |
| `people_fully_vaccinated` | Cumulative number of people who received all doses prescribed by the vaccination protocol |
| `hosp`                    | Number of hospitalized patients on date                      |
| `icu`                     | Number of hospitalized patients in intensive therapy on date |
| `vent`                    | Number of patients requiring invasive ventilation on date    |
| `population`              | Total population                                             |

The dataset also includes [policy measures](https://covid19datahub.io/articles/docs.html#policy-measures) by Oxford's government response tracker, and a set of [keys](https://covid19datahub.io/articles/docs.html#external-keys) to match the data with [Google](https://www.google.com/covid19/mobility/) and [Apple](https://www.apple.com/covid19/mobility) mobility reports, with the [Hydromet dataset](https://github.com/CSSEGISandData/COVID-19_Unified-Dataset/tree/master/Hydromet), and with spatial databases such as [Eurostat](https://ec.europa.eu/eurostat/web/nuts/nuts-maps) for Europe or [GADM](https://gadm.org/) worldwide.

## Administrative divisions

The data are provided at 3 different levels of granularity:

- level 1: national-level data (e.g., countries)
- level 2: sub-national data (e.g., regions/states)
- level 3: lower-level data (e.g., municipalities/counties)

## Download the data

All the data are available to download at the [download centre](https://covid19datahub.io/articles/data.html).

## How it works

COVID-19 Data Hub is developed around 2 concepts: 

- data sources
- countries  

To extract the data for one country, different data sources may be required. For this reason, the code in the [R folder](https://github.com/covid19datahub/COVID19/tree/master/R) is organized in two main types of files:

- files representing a data source (prefix `ds_`)
- files representing a country (prefix `iso_`)

The `ds_` files implement a wrapper to pull the data from a provider and import them in an R `data.frame` with standardized column names. The `iso_` files take care of merging all the data sources needed for one country, and to map the identifiers used by the provider to the `id` listed in the [CSV files](https://github.com/covid19datahub/COVID19/tree/master/inst/extdata/db). Finally, the function [`covid19`](https://github.com/covid19datahub/COVID19/blob/master/R/covid19.R) takes care of downloading the data for all countries at all levels.

The code is run continuously on a dedicated Linux server to crunch the data from the providers.  In principle, one can use the function `covid19` from the repository to generate the same data we provide at the [download centre](https://covid19datahub.io/articles/data.html#latest-data). However, this takes between 1-2 hours, so that downloading the pre-computed files is typically more convenient.

## Contribute

If you find some issues with the data, please [report a bug](https://github.com/covid19datahub/COVID19/issues).

## Academic publications

The first version of the project is described in *"COVID-19 Data Hub"*, [Journal of Open Source Software, 2020](https://doi.org/10.21105/joss.02376). The implementation details and the latest version of the data are described in *"A worldwide epidemiological database for COVID-19 at fine-grained spatial resolution"*, [Scientific Data, Nature, 2022](https://doi.org/10.1038/s41597-022-01245-1). You can browse the publications that use COVID-19 Data Hub [here](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=1585537563493742217) and [here](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=3406901022968697451). Please [cite](/authors.html) our paper(s) when using COVID-19 Data Hub.

## Cite as

We have invested a lot of time and effort in creating [COVID-19 Data Hub](https://covid19datahub.io), please cite the following when using it:

*Guidotti, E., Ardia, D., (2020), "COVID-19 Data Hub", Journal of Open Source Software 5(51):2376, doi: [10.21105/joss.02376](https://doi.org/10.21105/joss.02376).*

A BibTeX entry for LaTeX users is:

```latex
@Article{guidotti2020,
    title = {COVID-19 Data Hub},
    year = {2020},
    doi = {10.21105/joss.02376},
    author = {Emanuele Guidotti and David Ardia},
    journal = {Journal of Open Source Software},
    volume = {5},
    number = {51},
    pages = {2376}
}
```

The implementation details and the latest version of the data are described in:

*Guidotti, E., (2022), "A worldwide epidemiological database for COVID-19 at fine-grained spatial resolution", Sci Data 9, 112, doi: [10.1038/s41597-022-01245-1](https://doi.org/10.1038/s41597-022-01245-1)*

A BibTeX entry for LaTeX users is:

```latex
@Article{guidotti2022,
    title = {A worldwide epidemiological database for COVID-19 at fine-grained spatial resolution},
    year = {2022},
    doi = {10.1038/s41597-022-01245-1},
    author = {Emanuele Guidotti},
    journal = {Scientific Data},
    volume = {9},
    number = {1},
    pages = {112}
}
```

## Terms of use

By using COVID-19 Data Hub, you agree to our [terms of use](https://covid19datahub.io/LICENSE.html).

## Supported by 

<div style="height:96px">
<img height="96" src="man/figures/RConsortium.png" alt="R Consortium" style="margin-right:8px"/>
<img height="96" src="man/figures/ivado.png" alt="IVADO" style="margin-right:8px"/>
<img height="96" src="man/figures/hec-montreal.jpg" alt="HEC Montréal" style="display:inline-block;margin-right:8px" />
<img height="96" src="man/figures/hackzurich.jpeg" alt="Hack Zurich" style="display:inline-block;margin-right:8px" />
<img height="96" src="man/figures/unimi.jpg" alt="Università degli Studi di Milano" style="display:inline-block;margin-right:8px" />
<img height="96" src="man/figures/usi.png" alt="University of Lugano" style="display:inline-block;margin-right:8px" />
</div>


