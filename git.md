# How-to work with Git to contribute?

Let me explain how to use Git to contribute to the project. Three client interfaces are described - *CLI* (terminal), *Github Desktop* and *RStudio*.

The procedure consists of following steps:
* Forking the repository
* Cloning the fork
* Branching (optional)
* Implementation itself
* Testing
* Publishing (commit, push)
* Pull request to merge

**Scenario**

*You found a live source for COVID19 data. Since we do not read from the source yet, you can implement it for us and extend the project.*

> Let's say that you would like to add COVID data for *United States*. These data are published by reliable institution, e.g. *US Government* (`govUS`).

Your contribution is especially essential, if the data is described in a local language (that you speak).

> In case of *United States* state data from Luisiana might be in French.

Before you start, make sure we really do not read from the source already. Even if we have the data, the official data source is better than the general one. Sources are listed at [inst/extdata/db/_src.csv](https://github.com/covid19datahub/COVID19/blob/master/inst/extdata/db/_src.csv).

## Forking

To make a contribution, start with **forking the repository** into your own personal Github.

![fork.png](https://drive.google.com/uc?export=view&id=1x-NekySYsZFytJWMR5C5ZUHhDBYE5kPj)

After the forking process you will be automatically forwarded to your fork. Its URL is `https://github.com/<user>/COVID19.git`, where `<user>` is your Github username.

## Cloning

**Clone the fork** to your computer using RStudio, Github Desktop or CLI.

### Cloning using Github desktop

![githubdesktop_clone1.png](https://drive.google.com/uc?export=view&id=1Ya7JIWrPBdkhaCsgTG1J0_irUtZ075BC)
![githubdesktop_clone2.png](https://drive.google.com/uc?export=view&id=17uh_eV74L_2QhNaSKMrmydFK0YFEUXGT)

### Cloning using RStudio

![rstudio_clone1.png](https://drive.google.com/uc?export=view&id=1FJwEN4VrvqxRfbLnr410iW8wyYw_taSw)
![rstudio_clone2.png](https://drive.google.com/uc?export=view&id=1ULcgv4tZwM8z5h6PrYyoyEmqtZ3fYMY-)
![rstudio_clone3.png](https://drive.google.com/uc?export=view&id=1G9MP6P3MmA7LUBtZIyHCppl_ACXytmtC)
![rstudio_clone4.png](https://drive.google.com/uc?export=view&id=16ZF5zGeqb9jFJSqqTicP4wLpesvuD6_u)

### Cloning using CLI

```bash
# either via https
git clone https://www.github.com/<username>/COVID19.git
# or via ssh
git clone ssh://git@github.com/<username>/COVID19.git
```

## Branching (optional)

After cloning you can optionally create a **branch** for your changes. This will allow you to make multiple independent contributions.

### Branching using Github desktop

![githubdesktop_branch1.png](https://drive.google.com/uc?export=view&id=1dW7L2s4KqWuXsEqzp_4i6BTLhc6fYnzz)
![githubdesktop_branch2.png](https://drive.google.com/uc?export=view&id=1TsddWETvS7vD7Ngzvzc2lL-W5Rjw3AQI)
### Branching using RStudio

![rstudio_branch.png](https://drive.google.com/uc?export=view&id=1EB838bsxFixKPhifagCKK3GJe-OksW6i)

### Branching using CLI

```bash
# go to the directory
cd COVID19
# create branch (from current branch)
git branch usa
# checkout to the branch
git checkout usa
```

## Implementation

Data sources are implemented in `R/ds_*.R`, countries in `R/iso_*.R`. Copy template [R/ds_datasource.R](https://github.com/covid19datahub/COVID19/blob/master/R/ds_datasource.R) when creating a new datasource or [R/iso_ISO.R](https://github.com/covid19datahub/COVID19/blob/master/R/iso_ISO.R) when creating a new country.

```bash
# create a datasource
cp R/ds_datasource.R R/ds_govUS.R # US government data source
# create a country
cp R/iso_ISO.R R/iso_USA.R # USA
```

**Implement** the functionality. Keep in mind following:
* Function `USA()` from `R/iso_USA.R` returns country data of USA on different levels.
  * Level 1 = whole USA
  * Level 2 = US states (*Texas*, *California*, *Florida*, ...)
  * Level 3 = US municipalities (*New York*, *Miami*, *Wappingers Falls*, ...)
* Function `USA()` fetches data by calling datasource function `govUS()` from `R/ds_govUS.R`.
* Regional/city data must define column `id`, matching the slow changing data id in [inst/extdata/db/*.csv`](https://github.com/covid19datahub/COVID19/blob/master/inst/extdata/db/_src.csv).
* Unavailable data
  * Return `NULL` if data on a certain level is not available.
  * Specify only variables the data is available for. Missing variables are handled.
  * Missing data on some dates are also handled.
  * Sorting is handled. If you sum cumulatively, you must sort it before!

All the relevant information about implementation can be found in [README.md](https://github.com/covid19datahub/COVID19/blob/master/README.md) or [CONTRIBUTING.md](https://github.com/covid19datahub/COVID19/blob/master/CONTRIBUTING.md). 

## Build and test

Once you are done, test the functionality, do not forget first to build the package (in RStudio `Build > Intall and Restart`).

![rstudio_build.png](https://drive.google.com/uc?export=view&id=12X76zvRbgy_IO8UnE-HFigpNsp_7-J8D)

To run your code, type into R console:

```r
require(COVID19)
# country level data
x1 <- COVID19::covid19("USA", level = 1, cache = FALSE)
# state (region) level data
x2 <- COVID19::covid19("USA", level = 2, cache = FALSE)
# city level data
x3 <- COVID19::covid19("USA", level = 3, cache = FALSE)
```

Compare the data with other resources. Display the data in a table with

```r
View(x1)
```

## Commit and push

If the update is ready, publish your changes by commiting and pushing. It can be again done either in terminal or using RStudio or Github Desktop.

### Commiting in RStudio


![rstudio_commit1.png](https://drive.google.com/uc?export=view&id=1NjLN3tUN8EGdJEUbm0mweg6llWJwpfqW)
![rstudio_commit2.png](https://drive.google.com/uc?export=view&id=1T61H2zAQTL-Zrkmz_99F7gRhZwrRAbR3)

#### Commiting in Github desktop

![githubdesktop_commit1.png](https://drive.google.com/uc?export=view&id=1U9ENBvjRLXawVYlYN4HYO2Or-2a0IurD)

### Commiting in CLI

```bash
# create commit
git add .
git commit -m "USA level 2 implemented."
# push into remote repository (if in master branch)
git push
# if in separate branch, add additional parameter to mirror branch
git push --set-upstream origin usa
```

## Create pull request

Open your repository fork in your browser.

Create pull request from shown branch (master default) by `New pull request` (marked by yellow rectangle).

![pullrequest1.png](https://drive.google.com/uc?export=view&id=1HcnoJRJ4otlgAjFg0vE8c1aEDzm-rNoB)

If you have created a new branch, click on `branches` (marked by red rectangle) to select branch to create pull request from.

![pullrequest2.png](https://drive.google.com/uc?export=view&id=16pKdC3JJINTR4FgHDD_P7Rl_AmA0-G6g)

Fill needed information in the form and create pull request.

![pullrequest3.png](https://drive.google.com/uc?export=view&id=1ceklLl0MFA4LqDrgqAaPyob3bxFQeS3w)

We shall review your changes shortly and let you know.











