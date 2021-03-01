# COVID-19 DATA HUB - TEST FILE
# 
# Install this package and run this script based on
# https://testthat.r-lib.org/
#
# Additional information on testing R packages
# http://r-pkgs.had.co.nz/tests.html

library("testthat")

# download timeout for large files
options("timeout" = 60*60)

# run tests
test_check("COVID19")
