# How to contribute

_Be patient, be friendly, and focus on ideas. We are all here to learn and improve!_

__If you are new to GitHub, follow 3 simple steps to collaborate on the project:__

1. In the top-right corner of this page, click **Fork** to [copy the repository](https://help.github.com/en/github/getting-started-with-github/fork-a-repo)
2. Make changes to your fork:
   1. download [GitHub Desktop](https://desktop.github.com/)
   2. [clone your own fork](https://help.github.com/en/desktop/contributing-to-projects/cloning-and-forking-repositories-from-github-desktop#cloning-repositories) to create a local copy on your computer 
   3. work on the local copy on your computer and save changes by [creating a commit](https://help.github.com/en/desktop/contributing-to-projects/committing-and-reviewing-changes-to-your-project)
3. Once you are ready to propose your changes to the public, [create a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork) 

## Contributing Guidelines for R users

- Find data sources for **real-time data** such as number of cases, deaths, tests, hospitalized and other **fast-changing variables**. See the [data coverage table](https://github.com/emanuele-guidotti/COVID19#csv-data-files) to avoid working on something that is already available.
- Write R function(s) to import the latest data, just like [this](https://github.com/emanuele-guidotti/COVID19/blob/master/R/openZH.R). The return of the function must be a `data.frame` containing the columns `date`, `country`, `state`, `city`, `lat`, `lng` and the variables  documented [here](https://github.com/emanuele-guidotti/COVID19#csv-data-files). Additional variables can be included and some columns may be missing. Do not clean the data. The internal function [`covid19()`](<https://github.com/emanuele-guidotti/COVID19/blob/master/R/covid19.R>) takes care of it.
- Write R function(s) to export the data to the end-user, just like [this](https://github.com/emanuele-guidotti/COVID19/blob/master/R/switzerland.R). The function should be named with the name of the country, include the argument `raw = FALSE` and end with a call to `return(covid19(x, raw = raw))`. Merge the data with exogenous variables whenever possible by using the function `db()`, which relies on the data files available [here](https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db).

## Contributing Guidelines for non-R users

- Find data sources for **historical data** such as demographics, population density, age, air quality and other **slow-changing variables**. See the [data coverage table](https://github.com/emanuele-guidotti/COVID19#csv-data-files) to avoid working on something that is already available.
- Improve the csv file(s) available [here](https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db) by filling-in the missing values or extending the file(s) with additional variables.
- Clearly state where the data come from (data source + year) in your pull request. 

