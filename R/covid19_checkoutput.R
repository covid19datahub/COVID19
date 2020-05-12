check <- function(c, message) {
  # print error
  if(!c) warning(message)
  # return
  return(c)
}

checkoutput <- function(x) {
  
  status <- T
  eps    <- 1E-6
  
  # deaths <= confirmed
  status <- status | check(all(x$deaths <= x$confirmed | x$confirmed == 0, na.rm = T),
                           "deaths > confirmed")
  # confirmed <= tests
  status <- status | check(all(x$confirmed <= x$tests | x$tests == 0, na.rm = T),
                           "confirmed > tests")
  # recovered <= confirmed
  status <- status | check(all(x$recovered <= x$confirmed | x$confirmed == 0, na.rm = T),
                           "recovered > confirmed")
  # hosp <= confirmed
  status <- status | check(all(x$hosp <= x$confirmed | x$confirmed == 0, na.rm = T),
                           "hosp > confirmed")
  # icu <= hosp
  status <- status | check(all(x$icu <= x$hosp | x$hosp == 0, na.rm = T),
                           "icu > hosp")
  # vent <= confirmed
  status <- status | check(all(x$vent <= x$confirmed | x$confirmed == 0, na.rm = T),
                           "vent > confirmed")
  
  # female is percentage
  status <- status | check(all(x$pop_female >= 0 & x$pop_female < 100, na.rm = T),
                           "pop_female not in %")
  # population is fraction
  status <- status | check(all(abs(x$pop_14 + x$pop_15_64 + x$pop_65 - 1) < eps, na.rm = T),
                           "some of age pop_* not fractions")
  # death rate is fraction
  status <- status | check(all(x$pop_death_rate >= 0 & x$pop_death_rate <= 1, na.rm = T),
                           "pop_death_rate not fraction")
  # hospital beds is per 1000 people
  status <- status | check(all(x$hosp_beds <= 1000, na.rm = T),
                           "hosp_beds not per 1000 people")
  # smoking male is fraction
  status <- status | check(all(x$smoking_male >= 0 & x$smoking_male <= 1, na.rm = T),
                           "smoking_male not ratio")
  # smoking female is fraction
  status <- status | check(all(x$smoking_female >= 0 & x$smoking_female <= 1, na.rm = T),
                           "smoking_female not ratio")
  # health exp is fraction
  status <- status | check(all(x$health_exp >= 0 & x$health_exp <= 1, na.rm = T),
                           "health_exp not ratio")
  # health exp oop is fraction
  status <- status | check(all(x$health_exp_oop >= 0 & x$health_exp_oop <= 1, na.rm = T),
                           "health_exp_oop not ratio")
  
  # TODO: checks with output
  # ...
  
  # check ascending
  y <- x %>%
    dplyr::arrange_at('date') %>%
    dplyr::group_by_at('id') %>%
    # detect negative derivation
    dplyr::summarise(
      d_deaths_nonneg    = all(diff(deaths) >= 0, na.rm = T),
      d_confirmed_nonneg = all(diff(confirmed) >= 0, na.rm = T),
      d_tests_nonneg     = all(diff(tests) >= 0, na.rm = T),
      d_recovered_nonneg = all(diff(recovered) >= 0, na.rm = T) )
  
  # deaths not descending
  status <- status | check(y$d_deaths_nonneg,
                           "cumulative deaths descending")
  # confirmed not descending
  status <- status | check(y$d_confirmed_nonneg,
                           "cumulative confirmed descending")
  # tests not descending
  status <- status | check(y$d_tests_nonneg,
                           "cumulative tests descending")
  # recovered not descending
  status <- status | check(y$d_recovered_nonneg,
                           "cumulative recovered descending")
  
  # TODO: checks with output first derivation
  # ...
  
  # return
  return(status)
}