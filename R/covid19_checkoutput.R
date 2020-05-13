check <- function(c, message) {
  # print error
  if(!c) warning(message)
  # return
  return(c)
}

checkoutput <- function(x) {
  # id missing -> add foo id
  if(! "id" %in% colnames(x))
    x$id <- "id"
  
  status <- T
  eps    <- 1E-6
  cols <- colnames(x)
  
  # check date is present
  status <- status | check("date" %in% cols, "no date column")
  # check date column is date
  if("date" %in% cols)
    status <- status | check(inherits(x$date, c("Date","POSIXt")),
                             "column date of wrong type")
    
  # deaths <= confirmed
  if("confirmed" %in% cols & "deaths" %in% cols)
    status <- status | check(all(x$deaths <= x$confirmed | x$confirmed == 0, na.rm = T),
                             "deaths > confirmed")
  # confirmed <= tests
  if("confirmed" %in% cols & "tests" %in% cols) 
    status <- status | check(all(x$confirmed <= x$tests | x$tests == 0, na.rm = T),
                             "confirmed > tests")
  # recovered <= confirmed
  if("recovered" %in% cols & "confirmed" %in% cols)
    status <- status | check(all(x$recovered <= x$confirmed | x$confirmed == 0, na.rm = T),
                             "recovered > confirmed")
  # hosp <= confirmed
  if("hosp" %in% cols & "confirmed" %in% cols)
    status <- status | check(all(x$hosp <= x$confirmed | x$confirmed == 0, na.rm = T),
                             "hosp > confirmed")
  # icu <= hosp
  if("icu" %in% cols & "hosp" %in% cols)
    status <- status | check(all(x$icu <= x$hosp | x$hosp == 0, na.rm = T),
                             "icu > hosp")
  # vent <= confirmed
  if("vent" %in% cols & "confirmed" %in% cols)
    status <- status | check(all(x$vent <= x$confirmed | x$confirmed == 0, na.rm = T),
                             "vent > confirmed")
  
  # female is percentage
  if("pop_female" %in% cols)
    status <- status | check(all(x$pop_female >= 0 & x$pop_female < 100, na.rm = T),
                             "pop_female not in %")
  # population is fraction
  if("pop_14" %in% cols & "pop_15_64" %in% cols & "pop_65" %in% cols)
    status <- status | check(all(abs(x$pop_14 + x$pop_15_64 + x$pop_65 - 1) < eps, na.rm = T),
                             "some of age pop_* not fractions")
  # death rate is fraction
  if("pop_death_rate" %in% cols)
    status <- status | check(all(x$pop_death_rate >= 0 & x$pop_death_rate <= 1, na.rm = T),
                             "pop_death_rate not fraction")
  # hospital beds is per 1000 people
  if("hosp_beds" %in% cols)
    status <- status | check(all(x$hosp_beds <= 1000, na.rm = T),
                             "hosp_beds not per 1000 people")
  # smoking male is fraction
  if("smoking_male" %in% cols)
    status <- status | check(all(x$smoking_male >= 0 & x$smoking_male <= 1, na.rm = T),
                             "smoking_male not ratio")
  # smoking female is fraction
  if("smoking_female" %in% cols)
    status <- status | check(all(x$smoking_female >= 0 & x$smoking_female <= 1, na.rm = T),
                             "smoking_female not ratio")
  # health exp is fraction
  if("health_exp" %in% cols)
    status <- status | check(all(x$health_exp >= 0 & x$health_exp <= 1, na.rm = T),
                             "health_exp not ratio")
  # health exp oop is fraction
  if("health_exp_oop" %in% cols)
    status <- status | check(all(x$health_exp_oop >= 0 & x$health_exp_oop <= 1, na.rm = T),
                             "health_exp_oop not ratio")
  
  # TODO: checks with output
  # ...
  
  if('date' %in% cols & 'id' %in% cols) {
    # check ascending
    y <- x %>%
      dplyr::arrange_at('date') %>%
      dplyr::group_by_at('id') %>%
      dplyr::mutate(
        deaths    = if("deaths" %in% cols) deaths else 0,
        confirmed = if("confirmed" %in% cols) confirmed else 0,
        tests     = if("tests" %in% cols) tests else 0,
        recovered = if("recovered" %in% cols) recovered else 0,
        hosp      = if("hosp" %in% cols) hosp else 0,
        vent      = if("vent" %in% cols) vent else 0,
        icu       = if("icu" %in% cols) icu else 0 ) %>%
      # detect negative derivation
      dplyr::summarise(
        d_deaths_nonneg    = all(diff(deaths) >= 0, na.rm = T),
        d_confirmed_nonneg = all(diff(confirmed) >= 0, na.rm = T),
        d_tests_nonneg     = all(diff(tests) >= 0, na.rm = T),
        d_recovered_nonneg = all(diff(recovered) >= 0, na.rm = T),
        d_hosp_anyneg      = all(hosp == 0)|any(diff(hosp) < 0, na.rm = T),
        d_vent_anyneg      = all(vent == 0)|any(diff(vent) < 0, na.rm = T),
        d_icu_anyneg       = all( icu == 0)|any(diff(icu) < 0, na.rm = T) )
    
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
    # hosp not cumulative (any descending)
    status <- status | check(y$d_hosp_anyneg,
                             "hosp not cumulative")
    # vent not cumulative (any descending)
    status <- status | check(y$d_vent_anyneg,
                             "vent not cumulative")
    # icu not cumulative (any descending)
    status <- status | check(y$d_icu_anyneg,
                             "icu not cumulative")
    # TODO: checks with output first derivation
    # ...
  }
  
  # return
  return(status)
}
