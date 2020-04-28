# How to contribute

_Be patient, be friendly, and focus on ideas. We are all here to learn and improve!_

__If you are new to GitHub, follow 3 simple steps to collaborate on the project:__

1. In the top-right corner of this page, click **Fork** to [copy the repository](https://help.github.com/en/github/getting-started-with-github/fork-a-repo)
2. Make changes to your fork:
   1. download [GitHub Desktop](https://desktop.github.com/)
   2. [clone your own fork](https://help.github.com/en/desktop/contributing-to-projects/cloning-and-forking-repositories-from-github-desktop#cloning-repositories) to create a local copy on your computer 
   3. work on the local copy on your computer and save changes by [creating a commit](https://help.github.com/en/desktop/contributing-to-projects/committing-and-reviewing-changes-to-your-project)
3. Once you are ready to propose your changes to the public, [create a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork) 

## Contributing guidelines  for Everyone

1. Find data sources for **historical data** such as demographics, population density, age, air quality and other **slow-changing variables**. See the [data coverage table](https://storage.covid19datahub.io/coverage.html) to avoid working on something that is already available.
2. Improve the csv files available [here](https://github.com/covid19datahub/COVID19/tree/master/inst/extdata/db) by (programmatically or manually) filling-in the missing values or extending the files with additional variables.
3. Clearly state where the data come from (data source + year) in your pull request. 

## Contributing guidelines for R users

1. Find data sources for **real-time data** such as number of cases, deaths, tests, hospitalized and other **fast-changing variables**. See the [data coverage table](https://storage.covid19datahub.io/coverage.html) to avoid working on something that is already available.
2. Write R functions to import data from new data sources. Get started [here](https://github.com/covid19datahub/COVID19/blob/master/R/ds_datasource.R).
3. Write R functions to export the data to the end user. Get started [here](https://github.com/covid19datahub/COVID19/blob/master/R/iso_ISO.R).

## Useful links

- [Suggested data sources](https://github.com/covid19datahub/COVID19/blob/master/TODO.md)
- [Frequently asked questions](https://github.com/covid19datahub/COVID19/blob/master/FAQ.md)