# COVID19 v3.0.0

Version 3 represents a major update of COVID-19 Data Hub.

## Data Update

- added the data on the number of people who have received at least one vaccine dose
- added the number of people who are fully vaccinated according to the vaccination protocol
- added the data on population for all the administrative areas that we provide (more than 12,000)
- added the latest policy measures by Oxford Covid-19 Government Response Tracker
- added a new set of identifiers to enable geospatial analysis by linking to NUTS codes for Europe or to the GADM database worldwide
- to compute coordinates, the centroid is replaced by [`st_point_on_surface`](https://r-spatial.github.io/sf/reference/geos_unary.html), which guarantees to return a point on the surface of the administrative area

## Breaking changes

- the `id` for level 1 has been replaced with a 8-alphanumeric hash code for consistency with levels 2 and 3 
- the columns `key`, `key_alpha_2`, and `key_numeric` are replaced by `key_local`; containing the administrative area identifier used by the local authorities regardless of its type, e.g., numeric, 2-alpha code, etc. Codes such as FIPS now include leading zeros
- the column `currency` is renamed in `iso_currency`
- vintage data are now shipped in SQLite databases instead of ZIP folders
- vintage data sources are now reported in PDF files, instead of `src.csv`

## Website and documentation

- new website with interactive visualization of the data and data sources
- improved documentation

## New URLs

A new set of [endpoints](/articles/data.html) is available to download the data in several ways. The following files will continue to be updated for backward compatibility, but it is strongly recommended to switch to the new URLs:

| Old URL | New URL | Description | Format | Downloads |
|------------------------------------------------|----------------------------------------------|---------------|--------|-----------|
| https://storage.covid19datahub.io/rawdata-1.csv  | https://storage.covid19datahub.io/level/1.csv  | Worldwide country-level data | CSV | ![](https://storage.covid19datahub.io/downloads/rawdata-1.csv.svg) | 
| https://storage.covid19datahub.io/rawdata-1.zip  | https://storage.covid19datahub.io/level/1.csv.zip  | Worldwide country-level data | ZIP | ![](https://storage.covid19datahub.io/downloads/rawdata-1.zip.svg) | 
| https://storage.covid19datahub.io/rawdata-2.csv  | https://storage.covid19datahub.io/level/2.csv  | Worldwide state-level data | CSV | ![](https://storage.covid19datahub.io/downloads/rawdata-2.csv.svg) | 
| https://storage.covid19datahub.io/rawdata-2.zip  | https://storage.covid19datahub.io/level/2.csv.zip  | Worldwide state-level data | ZIP | ![](https://storage.covid19datahub.io/downloads/rawdata-2.zip.svg) | 
| https://storage.covid19datahub.io/rawdata-3.csv  | https://storage.covid19datahub.io/level/3.csv  | Worldwide city-level data | CSV | ![](https://storage.covid19datahub.io/downloads/rawdata-3.csv.svg) | 
| https://storage.covid19datahub.io/rawdata-3.zip  | https://storage.covid19datahub.io/level/3.csv.zip  | Worldwide city-level data | ZIP | ![](https://storage.covid19datahub.io/downloads/rawdata-3.zip.svg) | 

## Deprecated files

The following files have been deprecated and are no longer maintained.

| URL | Description | Format | Downloads |
|-----------------------------------------------|-------------------------------------------|--------|-----------|
| ~~https://storage.covid19datahub.io/data-1.csv~~  | Pre-processed worldwide country-level data | CSV    | ![](https://storage.covid19datahub.io/downloads/data-1.csv.svg) |
| ~~https://storage.covid19datahub.io/data-2.csv~~  | Pre-processed worldwide state-level data | CSV    | ![](https://storage.covid19datahub.io/downloads/data-2.csv.svg) |
| ~~https://storage.covid19datahub.io/data-3.csv~~  | Pre-processed worldwide city-level data | CSV    | ![](https://storage.covid19datahub.io/downloads/data-3.csv.svg) |
| ~~https://storage.covid19datahub.io/data-1.zip~~  | Pre-processed worldwide country-level data | ZIP    | ![](https://storage.covid19datahub.io/downloads/data-1.zip.svg) |
| ~~https://storage.covid19datahub.io/data-2.zip~~  | Pre-processed worldwide state-level data | ZIP    | ![](https://storage.covid19datahub.io/downloads/data-2.zip.svg) |
| ~~https://storage.covid19datahub.io/data-3.zip~~  | Pre-processed worldwide city-level data | ZIP    | ![](https://storage.covid19datahub.io/downloads/data-3.zip.svg) |
| ~~https://storage.covid19datahub.io/data.log~~    | Log file                  | CSV    | ![](https://storage.covid19datahub.io/downloads/data.log.svg) |
| ~~https://storage.covid19datahub.io/rawdata.log~~ | Log file                  | CSV    | ![](https://storage.covid19datahub.io/downloads/rawdata.log.svg) |
| ~~https://storage.covid19datahub.io/src.csv~~ | Data sources | CSV | ![](https://storage.covid19datahub.io/downloads/src.csv.svg) |

