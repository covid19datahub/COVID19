# COVID-19 DATA HUB - TEST FILE
# 
# Install this package and run this script based on
# https://testthat.r-lib.org/
#
# This test script:
# - prints changes in the data with respect to the (cloud) snapshot of 1 hour ago (live data) and 2 days ago (vintage data)
# - raises warnings if data providers made changes requiring manual fix
# - raises errors if data providers made breaking changes (test failure)
#
# Additional information on testing R packages
# http://r-pkgs.had.co.nz/tests.html

library("testthat")

test_check("COVID19")
