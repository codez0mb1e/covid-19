'
#'
#' Forecasting COVID-19 Spread
#'



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
  
  # graphics
  library(ggplot2)
  library(ggthemes)
})



# Load COVID-19 data ----


# Get list of files in datasets container:
input_data_container <- "../input/covid19-global-forecasting-week-3.zip"

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


##
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



# Forecasting tools ----

#' Calculate RMSLE (root mean squared logarithmic error)
#' 
#' $RMSLE = \sqrt {\frac{1}{n} \sum_{i = 1}^{n} {(log(p_i + 1) - log(a_i + 1))^2}}$
#' where:
#' - $n$ is the total number of observations
#' - $p_i$ is each prediction
#' - $a_i$ is each actual value
#' - $log(x)$ is the natural logarithm of $x$
#' 
calc_RMSLE <- function(.actual, .pred) sqrt(mean((log(.pred + 1) - log(.actual + 1))^2))



# Baseline ----

# Naive approch: get last value
baseline <- valid %>% 
  group_by(country_region, province_state, date) %>% 
  summarise(actual = sum(confirmed_cases)) %>% 
  mutate(pred = lag(actual)) %>% 
  mutate(pred = if_else(is.na(pred), 0, pred))

ggplot(baseline, aes(x = actual, y = pred)) +
  geom_jitter()

calc_RMSLE(baseline$actual, baseline$pred)






