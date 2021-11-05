<a href="https://covid19datahub.io"><img src="https://storage.covid19datahub.io/logo.svg" align="right" height="128"/></a>

# COVID-19 Data Hub

[![](https://storage.covid19datahub.io/downloads/total.svg)](https://covid19datahub.io/articles/data.html) [![DOI](https://joss.theoj.org/papers/10.21105/joss.02376/status.svg)](https://doi.org/10.21105/joss.02376) [![eRum2020::CovidR](https://badgen.net/https/runkit.io/erum2020-covidr/badge/branches/master/covid19datahub?cache=300)](https://milano-r.github.io/erum2020-covidr-contest/covid19datahub.html)


The repository aims at developing a [unified dataset](https://covid19datahub.io/articles/data.html) by collecting worldwide fine-grained case data, merged with exogenous variables helpful for a better understanding of COVID-19.  Available in:

<p align="center">
<a href="https://covid19datahub.io/articles/api/r.html" target="_blank">R</a>
|
<a href="https://covid19datahub.io/articles/api/python.html" target="_blank">Python</a>
|
<a href="https://covid19datahub.io/articles/api/matlab.html" target="_blank">MATLAB</a>
|
<a href="https://covid19datahub.io/articles/api/scala.html" target="_blank">Scala</a>
|
<a href="https://covid19datahub.io/articles/api/julia.html" target="_blank">Julia</a>
|
<a href="https://covid19datahub.io/articles/api/node.html" target="_blank">Node.js</a>
|
<a href="https://covid19datahub.io/articles/api/excel.html" target="_blank">Excel</a>
</p>

The data are updated on an hourly basis. [Read more](https://covid19datahub.io/articles/data.html)


## Exciting news!
Version 3.0 of the Data Hub will be released soon! This includes a new set of identifiers to enable geospatial analysis by linking to the [GADM database](https://gadm.org/). [NUTS codes](https://ec.europa.eu/eurostat/web/nuts/nuts-maps) for Europe are also included. Data on the first and second doses of vaccines will be included as well. The data coverage for `population` has been significantly extended. What this means for you:

- if you are not using the columns `key`, `key_alpha_2`, and `key_numeric` of the dataset (see [here](https://covid19datahub.io/articles/docs.html)), nothing changes for you. 
- if you are using some of the columns above (e.g., FIPS codes for US), please use the new column `key_local`. This contains the main identifier used by the local authorities (usually the national institute of statistics) regardless of its type (e.g., numeric, 2 character code, other). For a short period  of time (starting 14 October 2021), both the previous keys and the new `key_local` are made available to help the transition.
- if you are accessing the columns by position (not recommended!) you may experience shifts in the column index.
- for any question, please open an [issue](https://github.com/covid19datahub/COVID19/issues)

## Historical Data

The dataset includes the time series of vaccines, tests, cases, deaths, recovered, hospitalizations, intensive therapy, policy measures and more. See the [full dataset documentation](https://covid19datahub.io/articles/docs.html).

## Administrative Areas

The data are available at different levels of granularity:

- admin area level 1: administrative area of top level, usually countries.
- admin area level 2: usually states, regions, cantons.
- admin area level 3: usually cities, municipalities.

## Direct Download

The latest and vintage CSV data files are available [here](https://covid19datahub.io/articles/data.html).

## Use Cases

See the [projects](https://covid19datahub.io/articles/usage.html) and [publications](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=1585537563493742217) that use COVID-19 Data Hub.

## Cite as

We have invested a lot of time and effort in creating [COVID-19 Data Hub](https://covid19datahub.io), please agree to the [Terms of Use](https://covid19datahub.io/LICENSE.html) and cite the following reference when using it:

*Guidotti, E., Ardia, D., (2020), "COVID-19 Data Hub", Journal of Open Source Software 5(51):2376, doi: [10.21105/joss.02376](https://doi.org/10.21105/joss.02376).*

A BibTeX entry for LaTeX users is:

```latex
@Article{,
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

## Supported by 

<div style="height:96px">
<img height="96" src="man/figures/RConsortium.png" alt="R Consortium" style="margin-right:8px"/>
<img height="96" src="man/figures/ivado.png" alt="IVADO" style="margin-right:8px"/>
<img height="96" src="man/figures/hec-montreal.jpg" alt="HEC Montréal" style="display:inline-block;margin-right:8px" />
<img height="96" src="man/figures/hackzurich.jpeg" alt="Hack Zurich" style="display:inline-block;margin-right:8px" />
<img height="96" src="man/figures/unimi.jpg" alt="Università degli Studi di Milano" style="display:inline-block;margin-right:8px" />
</div>


