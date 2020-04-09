
#'
#' Forecasting COVID-19 Spread
#'


# Methods:
# + previous value (baseline)
# + Indicators: simple moving average (SMA) exponential moving average (EMA)
# - ARIMA, ETS
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
  library(purrr)
  library(magrittr)
  
  # convert and formatting
  library(stringr)
  library(lubridate)
  
  # tools
  library(skimr)

  # forecasting
  library(xts)
  library(TTR)
  
  # graphics
  library(ggplot2)
})

source("core.R")



# Load COVID-19 data ----

# Get list of files in datasets container:
input_data_container <- "../data/covid19-global-forecasting-week-3.zip"

print(
  as.character(unzip(input_data_container, list = T)$Name)
)


# Load datasets:
data <- paste0(c("test", "train"), sep = ".csv") %>% 
  map_dfr(
    ~ read.csv(unz(input_data_container, .x), 
               na.strings = c(""),  header = T, sep = ",")
  )



# Preprocessing ----

## rename columns
data %<>% 
  rename(
    Forecast_Id = ForecastId,
    Confirmed_Cases = ConfirmedCases
  )

names(data) <- names(data) %>% str_to_lower


## separate train-test
data %<>% 
  mutate(
    type = if_else(is.na(forecast_id), "train", "test"),
    id = if_else(type == "train", id, forecast_id),
  ) %>% 
  select(-forecast_id)


## format date and remove leakage

data %<>% 
  mutate(date = ymd(date)) %>% 
  filter(!is.na(date))

test_since <- min(data[data$type == "test", ]$date)
test_since

data %<>% 
  filter(
    type == "test" | 
    (type == "train" & date < test_since)
  )


## view result
data %>% skim



# Split datasets ----

train <- data %>% 
  filter(
    type == "train" &
    date < ymd("2020-03-13")
  )

valid <- data %>% 
  filter(
    type == "train" &
    !(id %in% train$id)
  )

test <-  data %>% 
  filter(type == "test")


stopifnot(
  nrow(valid) > 0, 
  nrow(test) > 0,
  nrow(train) > nrow(valid),
  nrow(train) > nrow(test),
  
  !anyNA(train$confirmed_cases),
  !anyNA(valid$confirmed_cases),
  all(is.na(test$confirmed_cases)),
  
  !anyNA(train$fatalities),
  !anyNA(valid$fatalities),
  all(is.na(test$fatalities)),
  
  max(train$date) < min(valid$date),
  max(valid$date) < min(test$date)
)



# Baseline ----

# Calculate naive approch: get previous value
baseline <- data %>% 
  filter(type == "train") %>% 
  group_by(country_region, date) %>% 
  summarise(actual = sum(confirmed_cases)) %>% 
  mutate(pred = lag(actual)) %>% 
  mutate(pred = if_else(is.na(pred), 0, pred))

# Eval
RMSLE(baseline$actual, baseline$pred)



# SMA, EMA, previous value ----

# Calculate
sma_ema_pred <- data %>% 
  filter(type == "train") %>% 
  group_by(country_region, date) %>% 
  summarise(
    confirmed = sum(confirmed_cases, na.rm = T), 
    fatalities = sum(fatalities, na.rm = T)
  ) %>% 
  filter(n() > 8) %>% 
  transmute(
    date, 
    actual = confirmed, 
    
    # previous value
    prev = lag(confirmed),
    
    # SMAs
    SMA_2 = SMA(confirmed, n = 2), 
    SMA_4 = SMA(confirmed, n = 4), 
    SMA_8 = SMA(confirmed, n = 8), 
    
    # EMAs
    EMA_2 = EMA(confirmed, n = 2), 
    EMA_4 = EMA(confirmed, n = 4), 
    EMA_8 = EMA(confirmed, n = 8)
  ) %>% 
  ungroup %>% 
  na.omit
  

ggplot(
  sma_ema_pred %>% 
    filter(country_region == "Italy" & actual > 0) %>% 
    gather(
      key = "f", value = "value", -c(country_region, date, actual)
    ), 
  aes(x = date)
  ) +
  geom_line(aes(y = actual)) +
  geom_line(aes(y = value, color = f))


# Eval best fitted
list(sma_ema_pred$EMA_2, sma_ema_pred$EMA_4, sma_ema_pred$SMA_2, sma_ema_pred$SMA_4) %>% 
  map(~ RMSLE(sma_ema_pred$actual, .x))



