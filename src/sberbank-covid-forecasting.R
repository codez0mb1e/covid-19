
#'
#' Sberbank COVID-19 forecasting
#'


# Methods:
# + Naive approch (previous value)
# + Indicators: simple moving average (SMA) exponential moving average (EMA)
# + ARIMA, ETS
# - Linear models: linear regression, Quasi-Poisson Regression 
# - Decision trees: boosting
# - Neural networks: LSTM, AR RNN
# - SIR model



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

# Load COVID spread datasets

load_time_series <- function(.case_type) {
  fread(sprintf("../data/time_series_covid19_%s_global.csv", .case_type)) %>% 
    select(-c(`Province/State`, Lat, Long)) %>% 
    gather(key = "date", value = "n", -c(`Country/Region`)) %>% 
    rename(country = `Country/Region`) %>% 
    mutate(date = mdy(date))
}

spread <- load_time_series("confirmed") %>% rename(confirmed_n = n) %>% 
  inner_join(
    load_time_series("recovered") %>% rename(recovered_n = n),
    by = c("country", "date")
  ) %>% 
  inner_join(
    load_time_series("deaths") %>% rename(deaths_n = n),
    by = c("country", "date")
  )


stopifnot(
  nrow(spread) > 0
)

spread %>% skim



# Preprocessing ----
data <- spread %>% 
  group_by(country, date) %>% 
  summarise_if(is.integer, sum) %>% 
  ungroup


stopifnot(
  nrow(data) > 0,
  all(unique(data$country) %in% unique(spread$country)),
  !anyNA(data)
)


data %>% 
  gather(key = "key", value = "value", -c(country, date)) %>% 
  count(key)

data %>% skim

  
# TODO: enrich by new dataset
# TODO: generate future dataset



# Split datasets ----

last_observation_date <- max(data$date)

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
    date > last_observation_date - weeks(1)
  )


# TODO: add future dataset

stopifnot(
  nrow(valid) > 0, 
  nrow(test) > 0,
  nrow(train) > nrow(valid),
  nrow(train) > nrow(test),
  
  !anyNA(train$confirmed_n),
  !anyNA(valid$confirmed_n),
  !anyNA(is.na(test$confirmed_n)),
  
  !anyNA(train$deaths_n),
  !anyNA(valid$deaths_n),
  !anyNA(is.na(test$deaths_n)),
  
  max(train$date) < min(valid$date),
  max(valid$date) < min(test$date)
)


list(train, valid, test) %>%
  map(
    ~ list(n = nrow(.x), min_date = min(.x$date), max_date = max(.x$date))
  ) %>% 
  flatten



# Naive approch (previous value) ----

## Calculate
pred_naive <- data %>% 
  group_by(country) %>% 
  arrange(date) %>% 
  mutate(
    pred_confirmed_n = lag(confirmed_n),
    pred_deaths_n = lag(deaths_n)
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
MALE(pred_naive$confirmed_n, pred_naive$pred_confirmed_n)
MALE(pred_naive$deaths_n, pred_naive$pred_deaths_n)



# Indicators: SMA, EMA ----

## Calculate
pred_indicators <- data %>% 
  group_by(country) %>% 
  arrange(date) %>% 
  filter(n() > 8) %>% 
  mutate(
    # SMAs
    confirmed_sma_2 = SMA(confirmed_n, n = 2), 
    confirmed_sma_4 = SMA(confirmed_n, n = 4), 
    confirmed_sma_8 = SMA(confirmed_n, n = 8), 
    deaths_sma_2 = SMA(deaths_n, n = 2), 
    deaths_sma_4 = SMA(deaths_n, n = 4), 
    deaths_sma_8 = SMA(deaths_n, n = 8), 
    
    # EMAs
    confirmed_ema_2 = EMA(confirmed_n, n = 2), 
    confirmed_ema_4 = EMA(confirmed_n, n = 4), 
    confirmed_ema_8 = EMA(confirmed_n, n = 8),
    deaths_ema_2 = EMA(deaths_n, n = 2), 
    deaths_ema_4 = EMA(deaths_n, n = 4), 
    deaths_ema_8 = EMA(deaths_n, n = 8)
  ) %>% 
  mutate_at(
    vars(contains("ma_")),
    list(~ if_else(is.na(.), 0, .))
  ) %>% 
  ungroup %>% 
  filter(
    date >= min(test$date) & date < max(test$date)
  )


ggplot(
  pred_indicators %>% 
    filter(country %in% c("US", "UK", "Russia", "Korea, South", "China")) %>% 
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
list(pred_indicators$confirmed_sma_2, pred_indicators$confirmed_sma_4, pred_indicators$confirmed_ema_2, pred_indicators$confirmed_ema_4) %>% 
  map(~ MALE(pred_indicators$confirmed_n, .x))

list(pred_indicators$deaths_sma_2, pred_indicators$deaths_sma_4, pred_indicators$deaths_ema_2, pred_indicators$deaths_ema_4) %>% 
  map(~ MALE(pred_indicators$deaths_n, .x))




# ARIMA, ETS ----

predict_horizont <- 7


## ARIMA

pred_arima <- unique(data$country) %>% 
  map_dfr(
    function(.x) {
      m <- data %>% 
        # filter rows and cols
        filter(
          country == .x & 
          date < min(test$date)
        ) %>%
        # convert to time-series
        arrange(date) %>% 
        select(confirmed_n) %>% # TODO: compare all ***_n
        as.ts %>% 
        # ARIMA model
        auto.arima %>% 
        # forecast
        forecast(h = predict_horizont)
      
      tibble(
        country = rep(.x, predict_horizont),
        date = seq(min(test$date), max(test$date), by = "day"),
        pred = m$mean %>% as.numeric()
      )
    }
  ) %>% 
  # join with actual
  inner_join(
    test, by = c("country", "date")
  )


MALE(pred_arima$confirmed_n, pred_arima$pred)



## ETS

pred_ets <- unique(data$country) %>% 
  map_dfr(
    function(.x) {
      m <- data %>% 
        # filter rows and cols
        filter(
          country == .x & 
            date < min(test$date)
        ) %>%
        # convert to time-series
        arrange(date) %>% 
        select(confirmed_n) %>% # TODO: compare all ***_n
        as.ts %>% 
        # ARIMA model
        ets %>% 
        # forecast
        forecast(h = predict_horizont)
      
      tibble(
        country = rep(.x, predict_horizont),
        date = seq(min(test$date), max(test$date), by = "day"),
        pred = m$mean %>% as.numeric()
      )
    }
  ) %>% 
  # join with actual
  inner_join(
    test, by = c("country", "date")
  )


MALE(pred_ets$confirmed_n, pred_ets$pred)




# Save submission ----

# TODO
# format: date, country, prediction_confirmed, prediction_deaths
