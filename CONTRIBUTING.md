# How to contribute

_Be patient, be friendly, and focus on ideas. We are all here to learn and improve!_

__If you are new to GitHub, follow 3 simple steps to collaborate on the project:__

1. In the top-right corner of this page, click **Fork** to [copy the repository](https://help.github.com/en/github/getting-started-with-github/fork-a-repo)
2. Make changes to your fork:
   1. download [GitHub Desktop](https://desktop.github.com/)
   2. [clone your own fork](https://help.github.com/en/desktop/contributing-to-projects/cloning-and-forking-repositories-from-github-desktop#cloning-repositories) to create a local copy on your computer 
   3. work on the local copy on your computer and save changes by [creating a commit](https://help.github.com/en/desktop/contributing-to-projects/committing-and-reviewing-changes-to-your-project)
3. Once you are ready to propose your changes to the public, [create a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork) 

## Contributing guidelines for Everyone

To contribute to our project it is not necessary to know a programming language!
### How can I be helpful?
We are always looking for new sources of information on historical data such as demographics, population density, age, air quality and other slow-changing variables. See the [data coverage table](https://storage.covid19datahub.io/coverage.html) to avoid working on something that is already available.

### What sources are accepted?
The quality of the sources is one of our pillars. We always try to refer to government, university, federal sites or qualified information portals (such as Wikipedia) to ensure data quality.

### Which files should I work on?
[Here](https://github.com/covid19datahub/COVID19/tree/master/inst/extdata/db) you will find the csv files to work on. The level of detail is expressed as follows:
- *[ISO.csv](https://github.com/covid19datahub/COVID19/blob/master/inst/extdata/db/ISO.csv)* file is the one that deals with listing all the countries and collecting information at level 1 of granularity.
- The files relating to each country are used to specify other information at the finer granularity level (level 2 and level 3).
- *[_src.csv](https://github.com/covid19datahub/COVID19/blob/master/inst/extdata/db/_src.csv)* file is used to store sources.

You can improve the csv files available by (programmatically or manually) filling-in the missing values or extending the files with additional variables. 
[Here](https://github.com/covid19datahub/COVID19#dataset) you can find the list of variables we are currently working on.

**Don't forget to clearly state where the data come from (data source + year) in your pull request, we will take care of inserting it in the src file**

## Contributing guidelines for R users

1. Find data sources for **real-time data** such as number of cases, deaths, tests, hospitalized and other **fast-changing variables**. See the [data coverage table](https://storage.covid19datahub.io/coverage.html) to avoid working on something that is already available.
2. Write R functions to import data from new data sources. Get started [here](https://github.com/covid19datahub/COVID19/blob/master/R/ds_datasource.R).
3. Write R functions to export the data to the end user. Get started [here](https://github.com/covid19datahub/COVID19/blob/master/R/iso_ISO.R).

## Useful links

- [Suggested data sources](https://github.com/covid19datahub/COVID19/blob/master/TODO.md)
- [Frequently asked questions](https://github.com/covid19datahub/COVID19/blob/master/FAQ.md)
