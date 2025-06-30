[![](https://storage.covid19datahub.io/downloads/total.svg)](https://covid19datahub.io/articles/data.html)

# COVID-19 Data Hub <img src="man/figures/logo.png" width="200" align="right" />

Funded by the Institute for Data Valorization [IVADO](https://ivado.ca/en/) in 2020. Supported by the [R Consortium](https://www.r-consortium.org) from 2021 to 2024. Funded by the University of Lugano [USI](https://www.usi.ch/en) in 2025.

> The goal of COVID-19 Data Hub is to provide the research community with a [unified dataset](/articles/data.html) by collecting worldwide fine-grained case data, merged with exogenous variables helpful for a better understanding of COVID-19.

## Download the data

All the data are provided at the [download centre](/articles/data.html).

## Unified dataset

The dataset includes an extensive list of [epidemiological variables](/articles/docs.html#epidemiological-variables), several [policy measures](/articles/docs.html#policy-measures) by Oxford's government response tracker, and a set of [external keys](/articles/docs.html#external-keys) to match the data with [Google](https://www.google.com/covid19/mobility/) and [Apple](https://www.apple.com/covid19/mobility) mobility reports, with the [Hydromet dataset](https://github.com/CSSEGISandData/COVID-19_Unified-Dataset/tree/master/Hydromet), and with spatial databases such as [Eurostat](https://ec.europa.eu/eurostat/web/nuts/nuts-maps) for Europe or [GADM](https://gadm.org/) worldwide.

## Software packages

The [R](/articles/api/r.html) and [Python](/articles/api/python.html) packages simplify the interaction with the Data Hub. In general, it is possible to import the data in any software by reading the CSV files provided at the [download centre](/articles/data.html).

## Data transparency

The data acquisition pipeline is open source. All the code used to generate the data files can be found at our [GitHub repository](https://github.com/covid19datahub/COVID19/). In principle, one can use the function `covid19` from the repository to generate the same data available at the [download centre](/articles/data.html#latest-data). However, this takes between 1-2 hours, so that downloading the pre-computed files is typically more convenient. The full list of data sources where the data are pulled from is available [here](/reference/index.html).

## Research reproducibility

As most governments are updating the data retroactively, we provide [vintage data](/articles/data.html#vintage-data) to simplify reproducibility of academic research. These are immutable snapshots of the data taken each day. We gratefully acknowledge financial support by the [R Consortium](https://www.r-consortium.org/blog/2020/12/14/r-consortium-providing-financial-support-to-covid-19-data-hub-platform) in maintaining the vintage data.

## Academic publications

The first version of the project is described in *"COVID-19 Data Hub"*, [Journal of Open Source Software, 2020](https://doi.org/10.21105/joss.02376). The implementation details and the latest version of the data are described in *"A worldwide epidemiological database for COVID-19 at fine-grained spatial resolution"*, [Scientific Data, Nature, 2022](https://doi.org/10.1038/s41597-022-01245-1). You can browse the publications that use COVID-19 Data Hub [here](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=1585537563493742217) and [here](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=3406901022968697451). Please [cite](/authors.html) our paper(s) when using COVID-19 Data Hub.

<!--
## In the news

- [LexTech Institute, 03/2021](https://www.lextechinstitute.ch/covid-19-data-hub/)
- [CScience, 02/2021](http://www.cscience.ca/2021/02/10/exploiter-les-donnees-pour-enrayer-la-pandemie/)
- [R Consortium, 02/2021](https://www.r-consortium.org/blog/2021/02/09/covid-19-data-hub)
- [University of Neuchâtel, 12/2020](https://www.unine.ch/unine/home/pour-les-medias/communiques-de-presse/les-donnees-de-la-covid-19-sur-u.html)
- [Quartier L!bre, 11/2020](https://quartierlibre.ca/regrouper-les-donnees-mondiales-sur-la-covid-19/)
- [HEC Montréal, 09/2020](https://www.hec.ca/en/research/take-a-closer-look/reliable-unified-data.html) 
- [Statistical Society of Canada, 06/2020](https://ssc.ca/en/publications/ssc-liaison/vol-34-3-june-2020/news-hec-montreal)
- [Institute for Data Valorization, 06/2020](<https://ivado.ca/en/covid-19/#phares>)
- [Winner of the eRum2020 CovidR contest, 06/2020](<https://milano-r.github.io/erum2020-covidr-contest/index.html>)
- [Data Science and Economics, University of Milano, 06/2020](<https://dse.cdl.unimi.it/en/avviso/notice-detail/covid-data-analysis>)
- [More Select COVID-19 Resources, 06/2020](https://rviews.rstudio.com/2020/06/03/more-select-covid-19-resources/)
- [Top 50 R resources on Novel COVID-19 Coronavirus, 03/2020](<https://towardsdatascience.com/top-5-r-resources-on-covid-19-coronavirus-1d4c8df6d85f>)
- ["Top 40" New CRAN Packages, 03/2020](<https://rviews.rstudio.com/2020/04/27/march-2020-top-40-new-cran-packages/>)
-->

## Contribute

If you find some issues with the data, please report a bug at our [GitHub repository](https://github.com/covid19datahub/COVID19/issues).

<a class="github-button" href="https://github.com/covid19datahub/COVID19" data-icon="octicon-star" data-size="large" data-show-count="true" aria-label="Star covid19datahub/COVID19 on GitHub">Star</a>
<script async defer src="https://buttons.github.io/buttons.js"></script>

## Terms of use

By using COVID-19 Data Hub, you agree to our [terms of use](/LICENSE.html).

## Authors

The project was initiated via the [R package COVID19](https://CRAN.R-project.org/package=COVID19) developed by [Emanuele Guidotti](https://guidotti.dev/) (University of Neuchâtel), leveraged by [David Ardia](https://ardiad.github.io/) (HEC Montréal) via the funding by [IVADO](https://ivado.ca/en/), enhanced by an awesome [open source community](/articles/contributors.html), and it is maintained by [Emanuele Guidotti](https://guidotti.dev/).

Logo courtesy of [Gary Sandoz](http://www.garysandoz.ch/index.html) and [Talk-to-Me](https://www.talk-to-me.ch/).

## Supported by

<img height="96" src="man/figures/RConsortium.png" alt="R Consortium" style="padding:8px"/>
<img height="96" src="man/figures/ivado.png" alt="IVADO" style="padding:8px"/>
<img height="96" src="man/figures/hec-montreal.jpg" alt="HEC Montréal" style="display:inline-block;padding:8px" />
<img height="96" src="man/figures/hackzurich.jpeg" alt="Hack Zurich" style="display:inline-block;padding:8px" />
<img height="96" src="man/figures/unimi.jpg" alt="Università degli Studi di Milano" style="display:inline-block;padding:8px" />
<img height="96" src="man/figures/usi.png" alt="University of Lugano" style="display:inline-block;padding:8px" />
