[![](https://storage.covid19datahub.io/downloads/total.svg)](https://covid19datahub.io/articles/data.html) [![DOI](https://joss.theoj.org/papers/10.21105/joss.02376/status.svg)](https://doi.org/10.21105/joss.02376)
[![eRum2020::CovidR](https://badgen.net/https/runkit.io/erum2020-covidr/badge/branches/master/covid19datahub?cache=300)](https://milano-r.github.io/erum2020-covidr-contest/covid19datahub.html) 

# COVID-19 Data Hub <img src="man/figures/logo.png" width="200" align="right" />

Funded by the Institute for Data Valorization [IVADO](https://ivado.ca/en/), Canada.

> The goal of COVID-19 Data Hub is to provide the research community with a [unified dataset](/articles/data.html) by collecting worldwide fine-grained case data, merged with exogenous variables helpful for a better understanding of COVID-19.

<!--
<iframe title="COVID-19 Data Hub" aria-label="Map" id="datawrapper-chart-3dO9Z" src="https://datawrapper.dwcdn.net/3dO9Z/4/" scrolling="no" frameborder="0" style="width: 0; min-width: 100% !important; border: none;" height="424"></iframe><script type="text/javascript">!function(){"use strict";window.addEventListener("message",(function(e){if(void 0!==e.data["datawrapper-height"]){var t=document.querySelectorAll("iframe");for(var a in e.data["datawrapper-height"])for(var r=0;r<t.length;r++){if(t[r].contentWindow===e.source)t[r].style.height=e.data["datawrapper-height"][a]+"px"}}}))}();</script>
-->

## Download the data

All the data are provided at the [download centre](/articles/data.html).

## Unified dataset

The dataset includes an extensive list of [epidemiological variables](/articles/docs.html#epidemiological-variables), several [policy measures](/articles/docs.html#policy-measures) by Oxford's government response tracker, and a set of [external keys](/articles/docs.html#external-keys) to match the data with [Google](https://www.google.com/covid19/mobility/) and [Apple](https://www.apple.com/covid19/mobility) mobility reports, with the [Hydromet dataset](https://github.com/CSSEGISandData/COVID-19_Unified-Dataset/tree/master/Hydromet), and with spatial databases such as [Eurostat](https://ec.europa.eu/eurostat/web/nuts/nuts-maps) for Europe or [GADM](https://gadm.org/) worldwide.

## Software packages

We release [R](/articles/api/r.html) and [Python](/articles/api/python.html) packages to simplify the interaction with the Data Hub. In general, it is possible to import the data in any software by reading the CSV files provided at the [download centre](/articles/data.html).

## Data transparency

The data acquisition pipeline is open source. All the code used to generate the data files can be found at our [GitHub repository](https://github.com/covid19datahub/COVID19/). In principle, one can use the function `covid19` from the repository to generate the same data we provide at the [download centre](/articles/data.html#latest-data). However, this takes between 1-2 hours, so that downloading the pre-computed files is typically more convenient. [Here](/reference/index.html) we provide the full list of data sources from which the data are pulled.

## Research reproducibility

As most governments are updating the data retroactively, we provide [vintage data](/articles/data.html#vintage-data) to simplify reproducibility of academic research. These are immutable snapshots of the data taken each day. We gratefully acknowledge financial support by the [R Consortium](https://www.r-consortium.org/blog/2020/12/14/r-consortium-providing-financial-support-to-covid-19-data-hub-platform) in maintaining the vintage data.

## Academic publications

See the [publications](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=1585537563493742217) that use COVID-19 Data Hub.

## Latest news

- 29/03/2022: The implementation details and the latest version of the data are described in *"A worldwide epidemiological database for COVID-19 at fine-grained spatial resolution"*, Scientific Data (Nature). Read more: [https://doi.org/10.1038/s41597-022-01245-1](https://doi.org/10.1038/s41597-022-01245-1)

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

## Contribute

If you find some issues with the data, please report a bug at our [GitHub repository](https://github.com/covid19datahub/COVID19/issues). Suggestions about where to find data that we do not currently provide are also very [welcome](https://github.com/covid19datahub/COVID19/issues/179)! Help our project grow: star the repo! 

<a class="github-button" href="https://github.com/covid19datahub/COVID19" data-icon="octicon-star" data-size="large" data-show-count="true" aria-label="Star covid19datahub/COVID19 on GitHub">Star</a>
<script async defer src="https://buttons.github.io/buttons.js"></script>

## Terms of use

By using COVID-19 Data Hub, you agree to our [terms of use](/LICENSE.html).

## Authors

The project was initiated via the [R package COVID19](https://CRAN.R-project.org/package=COVID19) developed by [Emanuele Guidotti](https://guidotti.dev/) (University of Neuchâtel), leveraged by [David Ardia](https://ardiad.github.io/) (HEC Montréal) via the funding by [IVADO](https://ivado.ca/en/), enhanced by an awesome [open source community](/articles/contributors.html), and it is maintained by [Emanuele Guidotti](https://guidotti.dev/).

Logo courtesy of [Gary Sandoz](http://www.garysandoz.ch/index.html) and [Talk-to-Me](https://www.talk-to-me.ch/).

## Supported by

<img height="96" src="man/figures/RConsortium.png" alt="R Consortium" style="margin-right:8px"/>
<img height="96" src="man/figures/ivado.png" alt="IVADO" style="margin-right:8px"/>
<img height="96" src="man/figures/hec-montreal.jpg" alt="HEC Montréal" style="display:inline-block;margin-right:8px" />
<img height="96" src="man/figures/hackzurich.jpeg" alt="Hack Zurich" style="display:inline-block;margin-right:8px" />
<img height="96" src="man/figures/unimi.jpg" alt="Università degli Studi di Milano" style="display:inline-block;margin-right:8px" />
