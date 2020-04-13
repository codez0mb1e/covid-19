
#'
#' Core functions
#'


#' Calculate (current - prev)/prev
calc_ratio <- function(.x, n = 1L) c(0, diff(.x, n))/(lag(.x, n) + 1e-7)


#' Calculate RMSLE (root mean squared logarithmic error)
#' 
#' $RMSLE = \sqrt {\frac{1}{n} \sum_{i = 1}^{n} {(log(p_i + 1) - log(a_i + 1))^2}}$
#' where:
#' - $n$ is the total number of observations
#' - $p_i$ is each prediction
#' - $a_i$ is each actual value
#' - $log(x)$ is the natural logarithm of $x$
#' 
RMSLE <- function(.actual, .pred) sqrt(mean((log(.pred + 1) - log(.actual + 1))^2))


#' Calculte Mean Absolute Logarithmic Error
MALE <- function(.actual, .pred) sum(abs(log10((.pred + 1)/(.actual + 1))))
