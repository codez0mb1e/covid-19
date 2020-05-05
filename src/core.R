
#'
#' Core time-series functions
#'



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

