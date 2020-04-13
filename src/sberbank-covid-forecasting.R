
#'
#' Sberbank COVID-19 forecasting
#'



# Import dependencies ----

options(max.print = 1e3, scipen = 999, width = 1e2)
options(stringsAsFactors = F)

suppressPackageStartupMessages({
  # data manipulations
  library(dplyr)
  library(tidyr)
  library(data.table)
  library(purrr)
  library(magrittr)
  
  # convert and formatting
  library(stringr)
  library(lubridate)
  
  # tools
  library(skimr)

  # forecasting
  library(xts)
  library(forecast)
  library(TTR)
  
  # graphics
  library(ggplot2)
})

source("core.R")
theme_set(theme_bw())



# Load datasets ----

## Load COVID spread datasets

load_time_series <- function(.case_type) {
  fread(sprintf("../data/time_series_covid19_%s_global.csv", .case_type)) %>% 
    select(-c(`Province/State`, Lat, Long)) %>% 
    gather(key = "date", value = "n", -c(`Country/Region`)) %>% 
    rename(country = `Country/Region`) %>% 
    mutate(date = mdy(date))
}

spread_raw <- load_time_series("confirmed") %>% rename(confirmed_n = n) %>% 
  inner_join(
    load_time_series("recovered") %>% rename(recovered_n = n),
    by = c("country", "date")
  ) %>% 
  inner_join(
    load_time_series("deaths") %>% rename(deaths_n = n),
    by = c("country", "date")
  )

stopifnot(nrow(spread_raw) > 0)

spread_raw %>% skim



## Today cases data

spread_today_raw <- fread("../data/cases_country.csv", na.strings = "")

spread_today_raw %<>% 
  filter(!is.na(ISO3)) %>% 
  transmute(
    country = ISO3,
    date = ymd(str_sub(Last_Update, start = 1, end = 10)),
    confirmed_n = Confirmed,
    deaths_n = Deaths,
    recovered_n = Recovered
  )

stopifnot(
  nrow(spread_today_raw) > 0, 
  unique(spread_today_raw$date) == Sys.Date(),
  nrow(spread_today_raw %>% group_by(country, date) %>% filter(n() > 1)) == 0
)


spread_today_raw %>% skim



## Load countries dataset
countries_raw <- read.csv(unz("../data/countries.csv.zip", "countries.csv"))

countries_raw %<>%
  select(-c(iso_alpha2, iso_numeric, name, official_name))
  
stopifnot(nrow(countries_raw) > 0)


countries_raw %>% skim



## Load submit sample
submit_raw <- fread("https://storage.yandexcloud.net/datasouls-ods/materials/9a76eb73-0965-45b4-bf1d-4920aa317ba1/sample_submission_dDoEbyO.csv")

submit_raw %<>%
  mutate(date = ymd(date)) %>% 
  mutate_at(vars(starts_with("prediction_")), list(~ NA_integer_)) %>% 
  filter(date > Sys.Date())

stopifnot(
  nrow(submit_raw) > 0,
  !anyNA(submit_raw %>% select(country, date)),
  all(unique(submit_raw$country) %in% unique(countries_raw$iso_alpha3)),
  nrow(submit_raw %>% group_by(country, date) %>% filter(n() > 1)) == 0
)

submit_raw %>% skim




# Preprocessing ----

## Join alltogether

data <- spread_raw %>% 
  ## calcultate daily spread stats
  group_by(country, date) %>% 
  summarise_if(is.integer, sum) %>% 
  ungroup %>% 
  
  ## convert to submit format 
  rename(ccse_name = country) %>% 
  inner_join(
    countries_raw %>% filter(!is.na(iso_alpha3)) %>% transmute(country = iso_alpha3, ccse_name), 
    by = "ccse_name"
  ) %>% 
  select(-ccse_name) %>% 
  
  ## add today cases data
  bind_rows(spread_today_raw) %>% 
  
  ## add submit sample
  bind_rows(
    submit_raw %>% 
      rename(confirmed_n = prediction_confirmed, deaths_n = prediction_deaths) %>% 
      mutate(recovered_n = NA_integer_)
  )


stopifnot(
  nrow(data) > 0,
  !anyNA(data %>% select(country, date))
)

data %>% skim



# TODO: enrich by new dataset



# ----

## Prepare data
data %<>% mutate_if(is.character, as.factor)



# Split datasets ----

last_observation_date <- max(data[!is.na(data$confirmed_n), ]$date)
last_observation_date


train <- data %>% 
  filter(
    date <= last_observation_date - weeks(2)
  )

valid <- data %>% 
  filter(
    date > last_observation_date - weeks(2) & 
    date <= last_observation_date - weeks(1)
  )

test <- data %>% 
  filter(
    date > last_observation_date - weeks(1) &
    date <= last_observation_date
  )


future <- data %>% filter(date > last_observation_date)


stopifnot(
  nrow(valid) > 0, 
  nrow(test) > 0,
  nrow(train) > nrow(valid),
  nrow(train) > nrow(test),
  
  !anyNA(train$confirmed_n),
  !anyNA(valid$confirmed_n),
  !anyNA(test$confirmed_n),
  
  !anyNA(train$deaths_n),
  !anyNA(valid$deaths_n),
  !anyNA(test$deaths_n),
  
  max(train$date) < min(valid$date),
  max(valid$date) < min(test$date),
  max(test$date) < min(future$date)
)


list(train, valid, test, future) %>%
  map(
    ~ list(
        n = nrow(.x), 
        countries_n = length(unique(.x$country)),
        min_date = min(.x$date), 
        max_date = max(.x$date)
      )
  ) %>% 
  bind_rows




# Naive approch (previous value) ----

## Calculate
pred_naive <- data %>% 
  group_by(country) %>% 
  arrange(date) %>% 
  mutate(
    pred_confirmed_n = lag(confirmed_n, n = 7),
    pred_deaths_n = lag(deaths_n, n = 7)
  ) %>% 
  mutate_at(
    vars(starts_with("pred_")),
    list(~ if_else(is.na(.), 0L, .))
  ) %>% 
  ungroup %>% 
  filter(
    date >= min(test$date) & date < max(test$date)
  )


ggplot(
  pred_naive, 
  aes(x = confirmed_n, y = pred_confirmed_n)) +
  
  geom_jitter() +
  
  scale_x_log10() +
  scale_y_log10()


## Evaluate
RMSLE(pred_naive$confirmed_n, pred_naive$pred_confirmed_n)
MALE(pred_naive$confirmed_n, pred_naive$pred_confirmed_n)



# Indicators: SMA, EMA, Double-EMA ----

## Calculate
pred_indicators <- data %>% 
  group_by(country) %>% 
  arrange(date) %>% 
  filter(
    n() > 7 &
    date < max(test$date)
  ) %>% 
  mutate(
    # SMAs
    confirmed_sma_7 = SMA(confirmed_n, n = 7), 
    deaths_sma_7 = SMA(deaths_n, n = 7), 
    
    # EMAs
    confirmed_ema_7 = EMA(confirmed_n, n = 7),
    deaths_ema_7 = EMA(deaths_n, n = 7),
    
    # DEMAs
    confirmed_dema_7 = DEMA(confirmed_n, n = 7),
    deaths_dema_7 = DEMA(deaths_n, n = 7)
  ) %>% 
  mutate_at(
    vars(contains("ma_")),
    list(~ if_else(is.na(.), 0, .))
  ) %>% 
  filter(
    date >= min(test$date)
  )


ggplot(
  pred_indicators %>% 
    filter(country %in% c("USA", "GBR", "RUS", "CHN")) %>% 
    select(country, date, starts_with("confirmed_")) %>% 
    gather(
      key = "f", value = "value", -c(country, date, confirmed_n)
    ), 
  aes(x = date)
  ) +
  
  geom_line(aes(y = confirmed_n)) +
  geom_line(aes(y = value, color = f)) +
  
  facet_grid(country ~ ., scales = "free")


# Eval best fitted
list(pred_indicators$confirmed_sma_7, pred_indicators$confirmed_ema_7, pred_indicators$confirmed_dema_7) %>% 
  map(~ MALE(pred_indicators$confirmed_n, .x))

list(pred_indicators$deaths_sma_7, pred_indicators$deaths_ema_7, pred_indicators$deaths_dema_7) %>% 
  map(~ MALE(pred_indicators$deaths_n, .x))



# ARIMA, ETS ----

#' Forecast confirmed cases
#'
#' @param .country 
#' @param .after_date 
#' @param .forecast_horizont 
#' @param .fun 
#' @param ... 
#'
forecast_confirmed_cases <- function(.country, .after_date, .forecast_horizont, .fun, ...) {
  
  dt <- data %>% 
    # filter rows and cols
    filter(
      country == .country & 
      date < .after_date
    ) %>%
    # convert to time-series
    arrange(date) %>% 
    select(confirmed_n)
  
  
  dt %>%  
    ts(frequency = 7) %>% 
    # ARIMA model
    .fun(...) %>% 
    # forecast
    forecast(h = .forecast_horizont)
}



#' Forecast confirmed cases (batch of countries)
#'
#' @param .fun 
#' @param ... 
#' 
forecast_confirmed_cases_batch <- function(.fun, ...) {
  
  forecast_horizont <- 7
  
  after_date <- max(test$date) + days() #!
  before_date <- max(test$date) + days(7) #!
  
  countries <- data %>% 
    filter(
      !is.na(confirmed_n) & date < after_date
    ) %>%
    group_by(country) %>% 
    filter(n() > 7) %>% 
    select(country) %>% 
    as_vector %>% 
    unique
  
  pred <- countries %>% 
    map_dfr(
      function(.x) {
        
        m <- forecast_confirmed_cases(.x, after_date, forecast_horizont, .fun, ...)
        
        tibble(
          country = rep(.x, forecast_horizont),
          date = seq(after_date, before_date, by = "day"),
          pred = m$mean %>% as.numeric %>% round %>% as.integer
        )
      }
    ) %>% 
    inner_join(
      data, by = c("country", "date")
    )
  
  
  #print(
  #  sprintf("RMSLE: %2f. MALE: %2f", 
  #          RMSLE(pred$confirmed_n, pred$pred),
  #          MALE(pred$confirmed_n, pred$pred))
  #)
  
  
  return(pred)
}


pred_hw <- forecast_confirmed_cases_batch(HoltWinters, beta = T, gamma = F)
pred_holt <- forecast_confirmed_cases_batch(holt)
pred_ets <- forecast_confirmed_cases_batch(ets)

pred_arima <- forecast_confirmed_cases_batch(auto.arima)




# Save submission ----

prediction_deaths <- data %>% 
  filter(date <= Sys.Date()) %>% 
  group_by(country) %>% 
  arrange(desc(date)) %>% 
  filter(row_number() == 1) %>% 
  ungroup %>% 
  transmute(
    country, 
    prediction_deaths = as.integer(deaths_n * 1.5),
    prediction_confirmed_d = as.integer(confirmed_n * 2)
  )
  


submit <- submit_raw %>% 
  select(country, date) %>% 
  left_join(
    pred_arima %>% transmute(country, date, prediction_confirmed = pred), 
    by = c("country", "date")
  ) %>% 
  left_join(
    prediction_deaths, by = "country"
  ) %>% 
  mutate(
    prediction_confirmed = if_else(is.na(prediction_confirmed), prediction_confirmed_d, prediction_confirmed)
  ) %>% 
  select(
    date, country, prediction_confirmed, prediction_deaths
  )


write.table(
  submit, "submit.csv", sep = ",", row.names = F, quote = F
)

# TODO
# format: date, country, prediction_confirmed, prediction_deaths
