
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
  library(forecast)
  library(TTR)
  
  # graphics
  library(ggplot2)
})

source("core.R")
source("datasets-uploader.R")



# Set forecasting params ----
forecast_horizont <- 7L



# Load datasets ----

## Load COVID spread datasets
spread_raw <- load_covid_spread()
spread_raw %>% skim


## Load countries dataset
countries_raw <- load_countries_stats()
countries_raw %>% skim


## Load submit sample
submit_raw <- load_submit_sample()
submit_raw %>% skim

stopifnot(
  all(unique(submit_raw$country_iso) %in% unique(countries_raw$country_iso))
)



# Preprocessing ----

## Preprocessing submit sample
submit <- submit_raw %>%
  inner_join(
    countries_raw %>% select(country, country_iso),
    by = "country_iso"
  ) %>% 
  select(-country_iso)

stopifnot(nrow(submit) == nrow(submit_raw))



## Join alltogether
data <- spread_raw %>% 
  bind_rows(
    submit %>% filter(date > max(spread_raw$date))
  )


stopifnot(
  nrow(data) > 0,
  !anyNA(data %>% select(country, date))
)

data %>% skim



## Set split reference dates
last_observation_date <- max(data[!is.na(data$confirmed_n), ]$date)
stopifnot(
  last_observation_date == Sys.Date()
)

# after - include bound, before - exclude bound
train_dates <- list(after = min(data$date), before = last_observation_date - weeks(2))
valid_dates <- list(after = last_observation_date - weeks(2), before = last_observation_date - weeks(1))
test_dates <- list(after = last_observation_date - weeks(1), before = last_observation_date)
submit_dates <- list(after = last_observation_date + days(1), before = max(data$date))

list(train_dates, valid_dates, test_dates, submit_dates) %>% bind_rows


# TODO: enrich by new dataset



## Prepare data
prepare_data <- function(dt) dt %>% 
  group_by(country) %>% 
  arrange(date) %>% 
  filter(date <= last_observation_date) %>% 
  filter(n() > forecast_horizont)

apply_test_only_filter <- function(dt) dt %>% filter(date >= test_dates$after & date < test_dates$before)


  
# Naive approch (previous value) ----

## Calculate
pred_naive <- data %>% 
  prepare_data %>% 
  
  mutate(
    pred_confirmed_n = lag(confirmed_n, n = forecast_horizont),
    pred_deaths_n = lag(deaths_n, n = forecast_horizont)
  ) %>% 
  mutate_at(
    vars(starts_with("pred_")),
    list(~ if_else(is.na(.), 0L, .))
  ) %>% 
  
  apply_test_only_filter
  


ggplot(pred_naive, aes(x = confirmed_n, y = pred_confirmed_n)) +
  
  geom_jitter(alpha = .25) +
  
  scale_x_log10() +
  scale_y_log10() +
  
  theme_bw()


## Evaluate
RMSLE(pred_naive$confirmed_n, pred_naive$pred_confirmed_n)
MALE(pred_naive$confirmed_n, pred_naive$pred_confirmed_n)



# Indicators: SMA, EMA, Double-EMA ----

## Calculate
pred_indicators <- data %>% 
  prepare_data %>% 
  
  mutate(
    # SMAs
    confirmed_sma = SMA(confirmed_n, n = forecast_horizont), 
    deaths_sma = SMA(deaths_n, n = forecast_horizont), 
    
    # EMAs
    confirmed_ema = EMA(confirmed_n, n = forecast_horizont),
    deaths_ema = EMA(deaths_n, n = forecast_horizont),
    
    # DEMAs
    confirmed_dema = DEMA(confirmed_n, n = forecast_horizont),
    deaths_dema = DEMA(deaths_n, n = forecast_horizont)
  ) %>% 
  mutate_at(
    vars(ends_with("ma")),
    list(~ if_else(is.na(.), 0, .))
  ) %>% 
  
  apply_test_only_filter


ggplot(
  pred_indicators %>% 
    filter(country %in% c("US", "Italy", "Russia", "China")) %>% 
    select(country, date, starts_with("confirmed_")) %>% 
    gather(
      key = "f", value = "value", -c(country, date, confirmed_n)
    ), 
  aes(x = date)
  ) +
  
  geom_line(aes(y = confirmed_n)) +
  geom_line(aes(y = value, color = f)) +
  
  facet_grid(country ~ ., scales = "free") +
  
  theme_bw() +
  theme(legend.position = "top")


# Eval best fitted
list(pred_indicators$confirmed_sma, pred_indicators$confirmed_ema, pred_indicators$confirmed_dema) %>% 
  map(~ MALE(pred_indicators$confirmed_n, .x))

list(pred_indicators$deaths_sma, pred_indicators$deaths_ema, pred_indicators$deaths_dema) %>% 
  map(~ MALE(pred_indicators$deaths_n, .x))



# ARIMA, ETS, Holt, Holt-Winters ----

#' Forecast confirmed cases
#'
#' @param .country 
#' @param .after_date 
#' @param .forecast_horizont 
#' @param .fun 
#' @param ... 
#'
forecast_confirmed_cases <- function(.country, .after_date, .forecast_horizont, .fun, ...) {
  require(dplyr)
  require(forecast)
  
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

  # TODO: it's bad style
  after_date <- test_dates$after + days() # last_observation_date + days()
  before_date <- test_dates$before # last_observation_date + days(forecast_horizont)
  
  countries <- data %>% 
    prepare_data %>% 
    select(country) %>% 
    as_vector %>% 
    unique
  
  countries %>% 
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
}


pred_hw <- forecast_confirmed_cases_batch(HoltWinters, beta = T, gamma = F)
pred_holt <- forecast_confirmed_cases_batch(holt)
pred_ets <- forecast_confirmed_cases_batch(ets)
pred_arima <- forecast_confirmed_cases_batch(auto.arima)


list(pred_hw, pred_holt, pred_ets, pred_arima) %>% 
  map_dfr(
    ~ list(
      RMSLE = RMSLE(.x$confirmed_n, .x$pred),
      MALE = MALE(.x$confirmed_n, .x$pred)
    )
  )


ggplot(
  list(pred_hw, pred_holt, pred_ets, pred_arima) %>% 
    map2_dfr(
      c("hw", "holt", "ets", "arima"),
      ~ .x %>% mutate(model = .y)
    ) %>% 
    filter(country %in% c("US", "Italy", "Russia", "China")), 
  aes(x = date)
  ) +
  
  geom_line(aes(y = pred, color = model)) +
  geom_line(aes(y = confirmed_n), linetype = "dashed") +
  
  facet_grid(country ~ ., scales = "free") +
  
  theme_bw() +
  theme(legend.position = "top")



## Facebook Prophet ----

#' Forecast confirmed cases
#'
#' @param .country 
#' @param .after_date 
#' @param .forecast_horizont 
#' @param ... 
#'
prophet_confirmed_cases <- function(.country, .after_date, .forecast_horizont, ...) {
  require(dplyr)
  require(prophet)
  
  # prepare data
  dt <- data %>% 
    # filter rows and cols
    filter(
      country == .country & 
      date < .after_date
    ) %>%
    # convert to time-series
    arrange(date) %>% 
    transmute(
      ds = date, y = confirmed_n
    )
  
  # fit model
  m <- prophet(dt, ...)
  
  # set future
  f <- make_future_dataframe(m, periods = .forecast_horizont, include_history = F)
  
  predict(m, f)
}



prophet_confirmed_cases_batch <- function() {
  
  # TODO: it's bad style
  after_date <- test_dates$after + days() # last_observation_date + days()
  before_date <- test_dates$before # last_observation_date + days(forecast_horizont)
  
  data %>% 
    prepare_data %>% 
    select(country) %>% 
    as_vector %>% 
    unique %>% 
    map_dfr(
      function(.x) {
        
        print(sprintf("Proccesing %s...", .x))
        
        pred <- prophet_confirmed_cases(.x, after_date, forecast_horizont, 
                                        yearly.seasonality = F, weekly.seasonality = F, daily.seasonality = F)
        
        tibble(
          country = rep(.x, forecast_horizont),
          date = seq(after_date, before_date, by = "day"),
          pred = pred$yhat
        )
      }
    ) %>% 
    inner_join(
      data, by = c("country", "date")
    )
}

pred_prophet <- prophet_confirmed_cases_batch()


print(
  sprintf("RMSLE: %2f. MALE: %2f", 
          RMSLE(pred_prophet$confirmed_n, pred_prophet$pred),
          MALE(pred_prophet$confirmed_n, pred_prophet$pred))
)

pred_prophet %>% 
  group_by(country) %>% 
  summarise(
    pred = sum(pred),
    confirmed_n = sum(confirmed_n)
  ) %>% 
  mutate(
    resudals = abs(pred - confirmed_n)/confirmed_n
  ) %>% 
  arrange(-resudals)



# DL ----

# TODO




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
  transmute(
    date,
    region = country,
    prediction_confirmed = if_else(is.na(prediction_confirmed), prediction_confirmed_d, prediction_confirmed),
    prediction_deaths
  )


write.table(submit, "submit.csv", sep = ",", row.names = F, quote = F)
