
#'
#' Core functions
#'


calc_ratio <- function(.x) c(0, diff(.x))/lag(.x)