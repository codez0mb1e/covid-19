COVID YAAA\! or Yet Another Analyze Attempt
================
16 April, 2020

#### Table of contents

  - [Load datasets](#load-datasets)
      - [Load COVID spread data](#load-covid-spread-data)
      - [Load countries data](#load-countries-data)
  - [Preprocessing](#preprocessing)
  - [Issue I: Absolute vs relative
    values](#issue-i:-absolute-vs-relative-values)
  - [Issue II: Dates vs smart reference
    date](#issue-ii:-dates-vs-smart-reference-date)
  - [Issue III: Infected vs active
    cases](#issue-iii:-infected-vs-active-cases)
  - [Issue IV: This is the past](#issue-iv:-this-is-the-past)
  - [Conclusion](#conclusion)

## Load datasets

### Load COVID spread data

``` r
#'
#' Load COVID-19 spread: infected, recovered, and fatal cases
#' Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series
#'
load_covid_spread <- function() {
  require(dplyr)
  require(data.table)
  require(purrr)
  require(tidyr)
  
  load_time_series <- function(.case_type) {
    
    path_pattern <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_%s_global.csv"
    
    fread(sprintf(path_pattern, .case_type)) %>% 
      rename(country = `Country/Region`) %>% 
      select(-c(`Province/State`, Lat, Long)) %>% 
      group_by(country) %>% 
      summarise_if(is.numeric, sum) %>% 
      ungroup %>% 
      gather(key = "date", value = "n", -country) %>% 
      mutate(date = mdy(date))
  }
  
  
  dt <- load_time_series("confirmed") %>% rename(confirmed_n = n) %>% 
    inner_join(
      load_time_series("recovered") %>% rename(recovered_n = n),
      by = c("country", "date")
    ) %>% 
    inner_join(
      load_time_series("deaths") %>% rename(deaths_n = n),
      by = c("country", "date")
    ) 
  
  
  stopifnot(nrow(dt) > 0)
  
  
  return(dt)
}


spread_raw <- load_covid_spread()
```

    ## Loading required package: data.table

    ## 
    ## Attaching package: 'data.table'

    ## The following objects are masked from 'package:xts':
    ## 
    ##     first, last

    ## The following objects are masked from 'package:lubridate':
    ## 
    ##     hour, isoweek, mday, minute, month, quarter, second, wday, week, yday, year

    ## The following object is masked from 'package:purrr':
    ## 
    ##     transpose

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

``` r
spread_raw %>% sample_n(10)
```

    ## # A tibble: 10 x 5
    ##    country     date       confirmed_n recovered_n deaths_n
    ##    <chr>       <date>           <int>       <int>    <int>
    ##  1 Zambia      2020-01-22           0           0        0
    ##  2 Somalia     2020-02-03           0           0        0
    ##  3 Cabo Verde  2020-02-13           0           0        0
    ##  4 Barbados    2020-02-05           0           0        0
    ##  5 Dominica    2020-02-07           0           0        0
    ##  6 Timor-Leste 2020-04-05           1           0        0
    ##  7 Barbados    2020-02-27           0           0        0
    ##  8 Spain       2020-04-14      172541       67504    18056
    ##  9 Kuwait      2020-01-29           0           0        0
    ## 10 Cabo Verde  2020-03-17           0           0        0

### Load countries data

``` r
#'
#' Load countries stats
#' Source: https://ods.ai/competitions/sberbank-covid19-forecast
#'
load_countries_stats <- function() {
  require(dplyr)
  require(magrittr)
  
  dt <- fread("https://raw.githubusercontent.com/codez0mb1e/covid-2019/master/data/countries.csv")
  
  dt %<>%
    select(-c(iso_alpha2, iso_numeric, name, official_name))
  
  stopifnot(nrow(dt) > 0)
  
  
  return(dt)
}


countries_raw <- load_countries_stats()
countries_raw %>% sample_n(10)
```

    ##    iso_alpha3        ccse_name density fertility_rate land_area median_age migrants population
    ## 1         UZB       Uzbekistan      79            2.4    425400         28    -8863   33469203
    ## 2         ESP            Spain      94            1.3    498800         45    40000   46754778
    ## 3         PNG Papua New Guinea      20            3.6    452860         22     -800    8947024
    ## 4         ISR           Israel     400            3.0     21640         30    10000    8655535
    ## 5         MNG         Mongolia       2            2.9   1553560         28     -852    3278290
    ## 6         KOR     Korea, South     527            1.1     97230         44    11731   51269185
    ## 7         SYR            Syria      95            2.8    183630         26  -427391   17500658
    ## 8         FIN          Finland      18            1.5    303890         43    14000    5540720
    ## 9         LIE    Liechtenstein     238             NA       160         NA       NA      38128
    ## 10        LBN          Lebanon     667            2.1     10230         30   -30012    6825445
    ##    urban_pop_rate world_share
    ## 1            0.50      0.0043
    ## 2            0.80      0.0060
    ## 3            0.13      0.0011
    ## 4            0.93      0.0011
    ## 5            0.67      0.0004
    ## 6            0.82      0.0066
    ## 7            0.60      0.0022
    ## 8            0.86      0.0007
    ## 9            0.15      0.0000
    ## 10           0.78      0.0009

## Preprocessing

``` r
stopifnot(
  nrow(spread_raw %>% group_by(country, date) %>% filter(n() > 1)) == 0
)

data <- spread_raw %>% 
  # add country population
  inner_join(
    countries_raw %>% transmute(ccse_name, country_iso = iso_alpha3, population) %>% filter(!is.na(country_iso)), 
    by = c("country" = "ccse_name")
  ) %>% 
  # calculate active cases
  mutate(
    active_n = confirmed_n - recovered_n - deaths_n
  ) %>% 
  # calculate cases per 1M population
  mutate_at(
    vars(ends_with("_n")),
    list("per_1M" = ~ ./population*1e6)
  )



## Calculte number of days since...
get_date_since <- function(dt, .case_type, .n) {
  dt %>% 
    group_by(country) %>% 
    filter_at(vars(.case_type), ~ . > .n) %>% 
    summarise(since_date = min(date))
}


data %<>% 
  inner_join(
    data %>% get_date_since("confirmed_n", 0) %>% rename(since_1st_confirmed_date = since_date),
    by = "country"
  ) %>% 
  inner_join(
    data %>% get_date_since("confirmed_n_per_1M", 1) %>% rename(since_1_confirmed_per_1M_date = since_date),
    by = "country"
  ) %>% 
  inner_join(
    data %>% get_date_since("deaths_n_per_1M", .1) %>% rename(since_dot1_deaths_per_1M_date = since_date),
    by = "country"
  ) %>% 
  mutate_at(
    vars(starts_with("since_")), 
    list("n_days" = ~ difftime(date, ., units = "days") %>% as.numeric)
  ) %>% 
  mutate_at(
    vars(ends_with("n_days")),
    list(~ if_else(. > 0, ., NA_real_))
  )
```

    ## Note: Using an external vector in selections is ambiguous.
    ## ℹ Use `all_of(.case_type)` instead of `.case_type` to silence this message.
    ## ℹ See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    ## This message is displayed once per session.

## Issue I: Absolute vs relative values

``` r
ggplot(data %>% filter_countries, aes(x = date)) +
  geom_col(aes(y = confirmed_n), alpha = .9) +
  
  scale_x_date(date_labels = "%d %b", date_breaks = "7 days") +

  facet_grid(country ~ .) +
  
  labs(x = "", y = "# of cases", 
       title = "COVID-19 Spread by Country", 
       subtitle = "Infected cases over time",
       caption = lab_caption) +
  
  theme(plot.caption = element_text(size = 8))
```

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
ggplot(data %>% filter_countries, aes(x = date)) +
  geom_col(aes(y = confirmed_n), alpha = .9) +
  
  scale_x_date(date_labels = "%d %b", date_breaks = "7 days") +
  scale_y_log10() +
  
  facet_grid(country ~ .) +
  
  labs(x = "", y = "# of cases", 
       title = "COVID-19 Spread by Country", 
       subtitle = "Infected cases over time",
       caption = lab_caption) +
  
  theme(plot.caption = element_text(size = 8))
```

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
ggplot(data  %>% filter_countries, aes(x = date)) +
  geom_col(aes(y = confirmed_n_per_1M), alpha = .9) +
  
  scale_x_date(date_labels = "%d %b", date_breaks = "7 days") +
  
  facet_grid(country ~ .) +
  
  labs(x = "", y = "# of cases per 1M", 
       subtitle = "Infected cases per 1 million popultation",
       title = "COVID-19 Spread (over time)", 
       caption = lab_caption) +
  
  theme(plot.caption = element_text(size = 8))
```

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
ggplot(data  %>% filter_countries, aes(x = date)) +
  geom_col(aes(y = confirmed_n_per_1M), alpha = .9) +
  
  scale_x_date(date_labels = "%d %b", date_breaks = "7 days") +
  scale_y_log10() +
  
  facet_grid(country ~ .) +
  
  labs(x = "", y = "# of cases per 1M", 
       subtitle = "Infected cases per 1 million popultation (over time)",
       title = "COVID-19 Spread by Country", 
       caption = lab_caption) +
  
  theme(plot.caption = element_text(size = 8))
```

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

## Issue II: Dates vs smart reference date

``` r
ggplot(
  data %>% filter_countries %>% filter(!is.na(since_1st_confirmed_date_n_days)), 
  aes(x = since_1st_confirmed_date_n_days)
  ) +
  
  geom_col(aes(y = confirmed_n), alpha = .9) +
  scale_y_log10() +
  
  facet_grid(country ~ .) +
  
  labs(x = "# of days since 1st infected case", y = "# of cases", 
       subtitle = "Infected cases since 1st infected case",
       title = "COVID-19 Spread by Country", 
       caption = lab_caption) +
  
  theme(plot.caption = element_text(size = 8))
```

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
ggplot(
  data %>% filter_countries %>% filter(!is.na(since_1_confirmed_per_1M_date_n_days)), 
  aes(x = since_1_confirmed_per_1M_date_n_days)
  ) +
  
  geom_col(aes(y = confirmed_n_per_1M), alpha = .9) +
  
  scale_y_log10() +
  xlim(c(0, 55)) +
  
  facet_grid(country ~ .) +
  
  labs(x = "# of days since 1 infected cases per 1M", y = "# of cases per 1M", 
       title = "COVID-19 Spread by Country", 
       subtitle = "Since 1 infected cases per 1 million popultation",
       caption = lab_caption) +
  
  theme(plot.caption = element_text(size = 8))
```

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

## Issue III: Infected vs active cases

``` r
plot_data <- data %>% 
  filter_countries %>% 
  filter(!is.na(since_1_confirmed_per_1M_date_n_days)) %>% 
  mutate(
    confirmed_n_per_1M = confirmed_n_per_1M, 
    recovered_n_per_1M = -recovered_n_per_1M,
    deaths_n_per_1M = -deaths_n_per_1M
  ) %>% 
  select(
    country, since_1_confirmed_per_1M_date_n_days, ends_with("_n_per_1M")
  ) %>% 
  gather(
    key = "case_state", value = "n_per_1M", -c(country, since_1_confirmed_per_1M_date_n_days, active_n_per_1M)
  )


ggplot(plot_data, aes(x = since_1_confirmed_per_1M_date_n_days)) +
  
  geom_col(aes(y = n_per_1M, fill = case_state), alpha = .9) +
  geom_line(aes(y = active_n_per_1M), color = "#0080FF", size = .25) +
  

  scale_fill_manual(element_blank(), 
                    labels = c("confirmed_n_per_1M" = "Infected cases", "recovered_n_per_1M" = "Recovered cases", "deaths_n_per_1M" = "Fatal cases"),
                    values = c("confirmed_n_per_1M" = "grey", "recovered_n_per_1M" = "gold", "deaths_n_per_1M" = "black")) +
  
  xlim(c(0, 55)) +
  
  facet_grid(country ~ ., scales = "free") +
  
  labs(x = "# of days since 1 infected cases per 1M", y = "# of cases per 1M", 
       title = "COVID-19 Spread by Countries", 
       subtitle = "Active cases trend since 1 infected cases per 1 million popultation. \nBlue line - infected cases minus recovered and fatal.\nNegative values indicate recovered and fatal cases.", 
       caption = lab_caption) +
  
  theme(
    legend.position = "top",
    plot.caption = element_text(size = 8)
  )
```

    ## Warning: Removed 75 rows containing missing values (position_stack).

    ## Warning: Removed 6 rows containing missing values (geom_col).

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

## Issue IV: This is the past

``` r
forecast_cases <- function(.country, .after_date, .forecast_horizont, .fun, ...) {
  
  dt <- data %>% 
    # filter rows and cols
    filter(
      country == .country & 
      date < .after_date
    ) %>%
    # convert to time-series
    arrange(date) %>% 
    select(active_n_per_1M)
  
  dt %>%  
    ts(frequency = 7) %>% 
    # ARIMA model
    .fun(...) %>% 
    # forecast
    forecast(h = .forecast_horizont)
}


forecast_horizont <- 7
after_date <- max(data$date) + days()

countries_list <- c("Belgium", "France", "Italy", "Netherlands", "Norway", "Portugal", "Spain", "Switzerland", "US", "Russia", "China", "Korea, South")

pred <- countries_list  %>% 
  map_dfr(
    function(.x) {
      
      m <- forecast_cases(.x, after_date, forecast_horizont, auto.arima)
      
      n_days_max <- max(data[data$country == .x, ]$since_1_confirmed_per_1M_date_n_days, na.rm = T)
      
      tibble(
        country = rep(.x, forecast_horizont),
        since_1_confirmed_per_1M_date_n_days = seq(n_days_max + 1, n_days_max + forecast_horizont, by = 1),
        pred = m$mean %>% as.numeric %>% round %>% as.integer,
        data_type = "Forecast"
      )
    }
  )



plot_data <- data %>% 
  filter(country %in% countries_list) %>% 
  transmute(
    country, active_n_per_1M, since_1_confirmed_per_1M_date_n_days, 
    data_type = "Historical data"
  ) %>% 
  bind_rows(
    pred %>% rename(active_n_per_1M = pred)
  ) %>% 
  mutate(
    double_every_14d = (1 + 1/14)^since_1_confirmed_per_1M_date_n_days, # double every 2 weeks
    double_every_7d = (1 + 1/7)^since_1_confirmed_per_1M_date_n_days, # double every week
    double_every_3d = (1 + 1/3)^since_1_confirmed_per_1M_date_n_days, # double every 3 days
    double_every_2d = (1 + 1/2)^since_1_confirmed_per_1M_date_n_days # double every 2 days
  )


active_n_per_1M_last <- plot_data %>% 
  group_by(country) %>% 
  arrange(desc(since_1_confirmed_per_1M_date_n_days)) %>% 
  filter(row_number() == 1) %>% 
  ungroup

plot_data %<>% 
  left_join(
    active_n_per_1M_last %>% transmute(country, active_n_per_1M_last = active_n_per_1M, since_1_confirmed_per_1M_date_n_days),
    by = c("country", "since_1_confirmed_per_1M_date_n_days")
  )
```

``` r
ggplot(plot_data, aes(x = since_1_confirmed_per_1M_date_n_days)) +
  
  geom_line(aes(y = double_every_7d), linetype = "dotted", color = "red", alpha = .65) +
  geom_line(aes(y = double_every_3d), linetype = "dotted", color = "red", alpha = .75) + 
  geom_line(aes(y = double_every_2d), linetype = "dotted", color = "red", alpha = .85) + 
  
  geom_line(aes(y = active_n_per_1M, color = country, linetype = data_type), show.legend = T) +
  geom_text(aes(y = active_n_per_1M_last + 20, label = country, color = country), 
            hjust = 0.5, vjust = 0, check_overlap = T, show.legend = F, fontface = "bold", size = 3.6) +

  annotate(geom = "text", label = "Cases double \n every 2 days", x = 17, y = 1550, vjust = 0, size = 3.1) +
  annotate(geom = "text", label = "...every 3 days", x = 25, y = 1800, vjust = 0, size = 3.1) +
  annotate(geom = "text", label = "...every week", x = 50, y = 1500, vjust = 0, size = 3.1) +
  
  scale_linetype_manual(values = c("longdash", "solid")) +
  
  xlim(c(10, 55)) +
  ylim(c(0, max(plot_data$active_n_per_1M))) +
  
  labs(x = "# of days since 1 infected cases per 1M", y = "# of cases per 1M", 
       title = "COVID-19 Spread by Country", 
       subtitle = "Active cases trend since 1 infected cases per 1 million popultation.", 
       caption = lab_caption) +
  
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    plot.caption = element_text(size = 8)
  )
```

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

Excellent\!

## Conclusion

Compare last plot with naive approach (below) and find your way :)

![](covid-19-yaaa_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

*Take care of yourself\!*
