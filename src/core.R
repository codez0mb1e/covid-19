
#'
#' Core time-series functions
#'


## Load dataset ----


#' Generate data
#'
#' @param n final x of the time series
#' @param n_timesteps shift for predicted value
#' @param amp amplitude of the cosine function
#' @param period period of the cosine function
#' @param x0 initial x of the time series
#' @param step step of the time series discretization
#' @param k exponential rate
#' 
generate_data <- function(n = 1e5, n_timesteps = 1, amp = 1, period = 1e3, x0 = 0, step = 1, k = 1e-4) {
  require(dplyr)
  
  # Generates an absolute cosine time series with the amplitude exponentially decreasing
  gen_cosine <- function() {
    n <- (n - x0) * step
    cos <- array(data = numeric(n), dim = c(n, 1, 1))
    for (i in 1:length(cos)) {
      idx <- x0 + i * step
      cos[[i, 1, 1]] <- amp * cos(2 * pi * idx / period)
      cos[[i, 1, 1]] <- cos[[i, 1, 1]] * exp(-k * idx)
    }
    cos
  }
  
  
  tibble(
    x1 = gen_cosine(),
    x2 = seq(0, 1, length.out = n)*amp,
    timestamp = seq(Sys.time() - seconds(n - 1), Sys.time(), by = 1)
    ) %>%
    mutate(
      y = lead(x1, n = n_timesteps, default = 0) #! TODO: x1 + x2
    )
}



## Preprocessing ----

#' Get splitting points
#'
#' @param .timestamps 
#' @param .ratio 
#'
get_splitter <- function(.timestamps, .ratio = c(.6, .2)) {
  stopifnot(
    is.POSIXt(.timestamps),
    is.numeric(.ratio) & length(.ratio) == 2
  )
  
  min_time <- min(.timestamps)
  range <- difftime(max(.timestamps), min_time, units = "secs")
  
  c(
    which.max( .timestamps > min_time + seconds(range*.ratio[1]) ),
    which.max( .timestamps > min_time + seconds(range*sum(.ratio)) )
  )
}


#' Apply splitter
#'
#' @param dt 
#' @param .splitter 
#' @param .verbose 
#'
apply_splitter <- function(dt, .splitter, .verbose = F) {
  require(dplyr)
  stopifnot(
    is.data.frame(dt),
    is.numeric(.splitter) & length(.splitter) == 2
  )
  
  splits <- list(
    train = dt[1:(.splitter[1] - 1), ],
    valid = dt[.splitter[1]:(.splitter[2] - 1), ],
    test = dt[.splitter[2]:nrow(dt), ]
  )
  
  if (.verbose) print(splits %>% map_dfr( ~ .x %>% summarise(after = min(timestamp), before = max(timestamp), count = n())))
  
  splits
}


#' Get scale attributes
#'
#' @param dt 
#' @param ... 
#'
get_scaler <- function(dt, ...) {
  require(dplyr)
  stopifnot(
    is.data.frame(dt)
  )
  
  scaled_dt <- dt %>% 
    select_if(is.numeric) %>% 
    scale(...)
  
  list(
    mean = attr(scaled_dt, "scaled:center"),
    std = attr(scaled_dt, "scaled:scale")
  )
}


#' Apply scale attibutes
#'
#' @param dt 
#' @param .attr 
#'
apply_scaler <- function(dt, .scaler) {
  require(dplyr)
  stopifnot(
    is.data.frame(dt),
    is.list(.scaler)
  )
  
  
  cols_include <- names(.scaler[[1]])
  cols_exclude <- setdiff(names(dt), cols_include)
  
  cbind(
    # not scaling columns
    dt %>% 
      select(all_of(cols_exclude)) %>% 
      as.matrix, 
    # scaling columns
    scale(
      dt %>% select(all_of(cols_include)), 
      center = .scaler$mean, scale = .scaler$std
  )) %>% 
  as_tibble %>% 
  mutate_at(
    vars(cols_include), as.numeric
  )
}


#' Unscale
#' 
#' WARN: support unscale only for 1 column
#'
#' @param dt 
#' @param .scaler 
#'
unscale <- function(dt, .scaler) {
  require(dplyr)
  require(purrr)
  stopifnot(
    is.data.frame(dt),
    is.list(.scaler) & (.scaler %>% flatten %>% length) == 2
  )

  dt %>% 
    mutate_at(
      vars(names(.scaler[[1]])),
      list(~ .x * .scaler$std + .scaler$mean)
    )
}



## Predict ----

#' Score predictions
#'
#' @param .origin 
#' @param .actual 
#' @param .pred 
#' @param .scaler 
#' @param .splitter 
#'
score_predictions <- function(.origin, .actual, .pred, .scaler, .splitter) {
  require(dplyr)
  require(tidyr)
  stopifnot(
    is.data.frame(.origin),
    is.numeric(.actual),
    is.numeric(.pred),
    is.list(.scaler),
    is.numeric(.splitter)
  )
  
  
  # get label scaler
  label_scaler <- .scaler %>% map(~ .["y"])
  
  # get timestampts
  time_col_values <- .origin[.splitter[2]:nrow(.origin), ]$timestamp
  
  # join actual, predicted and timestampts
  bind_rows(
    tibble(y = .pred, timestamp = time_col_values, source = "pred"),
    tibble(y = .actual, timestamp = time_col_values, source = "actual")
  ) %>% 
  # unscale actual and predicted 
  unscale(label_scaler) %>% 
  # pivot
  pivot_wider(names_from  = source, values_from = y) %>% 
  # calc resudals
  mutate(
    resudals = actual - pred
  )
}




## Evaluate ----


#' Calculate ratio
#' 
#' $Ratio = (t - (t - 1))/((t - 1) + eps)$
calc_ratio <- function(.x, n = 1L, eps = 1e-7) c(0, diff(.x, n))/(lag(.x, n) + eps)


#' Calculate Root Mean Squared Logarithmic Error
#' 
#' $RMSLE = \sqrt {\frac{1}{n} \sum_{i = 1}^{n} {(log(p_i + 1) - log(a_i + 1))^2}}$
#' where:
#' - $n$ is the total number of observations
#' - $p_i$ is each prediction
#' - $a_i$ is each actual value
#' - $log(x)$ is the natural logarithm of $x$
#' 
RMSLE <- function(.actual, .pred) sqrt(mean((log(.actual + 1) - log(.pred + 1))^2))


#' Calculate Root Mean Squared Error
#' 
RMSE <- function(.actual, .pred) sqrt(mean((.actual - .pred)^2))


#' Calculte Mean Absolute Logarithmic Error
#' 
MALE <- function(.actual, .pred) mean(abs(log10((.actual + 1)/(.pred + 1))))

