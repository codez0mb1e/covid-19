
#'
#' Datasets uploader
#'



#'
#' Load COVID-19 spread: infected, recovered, and fatal cases
#' Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series
#'
load_covid_spread <- function() {
  require(dplyr)
  require(data.table)
  require(purrr)
  require(tidyr)
  
  
  ## load historical spread data
  
  load_time_series <- function(.case_type) {
    
    path_pattern <- "../data/time_series_covid19_%s_global.csv"
    
    fread(sprintf(path_pattern, .case_type)) %>% 
      rename(country = `Country/Region`) %>% 
      select(-c(`Province/State`, Lat, Long)) %>% 
      group_by(country) %>% 
      summarise_if(is.numeric, sum) %>% 
      ungroup %>% 
      gather(key = "date", value = "n", -country)
  }
  
  
  hist_dt <- load_time_series("confirmed") %>% rename(confirmed_n = n) %>% 
    inner_join(
      load_time_series("recovered") %>% rename(recovered_n = n),
      by = c("country", "date")
    ) %>% 
    inner_join(
      load_time_series("deaths") %>% rename(deaths_n = n),
      by = c("country", "date")
    ) %>% 
    mutate(date = mdy(date))
  
  
  stopifnot(
    nrow(hist_dt) > 0,
    !anyNA(hist_dt),
    nrow(hist_dt %>% group_by(country, date) %>% filter(n() > 1)) == 0
  )
  
  
  ## load today spread data
  today_dt <- fread("../data/cases_country.csv", na.strings = "")
  
  today_dt %<>% 
    filter(!is.na(ISO3)) %>% 
    transmute(
      country = Country_Region,
      date = ymd(str_sub(Last_Update, start = 1, end = 10)),
      confirmed_n = Confirmed,
      deaths_n = Deaths,
      recovered_n = Recovered
    )
  
  stopifnot(
    nrow(today_dt) > 0, 
    !anyNA(hist_dt),
    unique(today_dt$date) == Sys.Date(),
    nrow(today_dt %>% group_by(country, date) %>% filter(n() > 1)) == 0
  )
  
  
  ## join altogether
  stopifnot(
    all(unique(today_dt$country) %in% unique(hist_dt$country)),
    min(today_dt$date) > max(hist_dt$date)
  )
  
  
  hist_dt %>% bind_rows(today_dt)
}


#'
#' Load countries stats
#' Source: https://ods.ai/competitions/sberbank-covid19-forecast
#'
load_countries_stats <- function() {
  require(dplyr)
  require(magrittr)
  
  dt <- read.csv(unz("../data/countries.csv.zip", "countries.csv"))
  
  dt %<>%
    filter(!is.na(iso_alpha3)) %>% 
    rename(country = ccse_name, country_iso = iso_alpha3) %>% 
    select(-c(iso_alpha2, iso_numeric, name, official_name))
  
  stopifnot(nrow(dt) > 0)
  
  
  return(dt)
}



#'
#' Load submit sample
#' Source: https://ods.ai/competitions/sberbank-covid19-forecast
#'
load_submit_sample <- function() {
  require(dplyr)
  require(magrittr)
  require(data.table)
  
  dt <- fread("https://storage.yandexcloud.net/datasouls-ods/materials/9a76eb73-0965-45b4-bf1d-4920aa317ba1/sample_submission_dDoEbyO.csv")
  
  dt %<>%
    transmute(
      date = ymd(date),
      country_iso = country,
      recovered_n = NA_integer_,
      confirmed_n = NA_integer_,
      deaths_n = NA_integer_
    )
  
  stopifnot(
    nrow(dt) > 0,
    !anyNA(dt %>% select(country_iso, date)),
    nrow(dt %>% group_by(country_iso, date) %>% filter(n() > 1)) == 0
  )
  
  
  return(dt)
}

