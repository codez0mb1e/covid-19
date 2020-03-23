COVID-19 Analytics
================
23 March, 2020

## Load dataset

Get datasets list:

``` r
input_data_container <- "../input/novel-corona-virus-2019-dataset.zip"

print(
  as.character(unzip(input_data_container, list = T)$Name)
)
```

    ## [1] "COVID19_line_list_data.csv"         "COVID19_open_line_list.csv"        
    ## [3] "covid_19_data.csv"                  "time_series_covid_19_confirmed.csv"
    ## [5] "time_series_covid_19_deaths.csv"    "time_series_covid_19_recovered.csv"

Load COVID-19 data:

``` r
covid_data <- read.csv(unz(input_data_container, "covid_19_data.csv"), 
                       na.strings = c("NA", "None", ""),
                       header = T, sep = ",")
```

Data structure:

``` r
str(covid_data)
```

    ## 'data.frame':    7926 obs. of  8 variables:
    ##  $ SNo            : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ ObservationDate: chr  "01/22/2020" "01/22/2020" "01/22/2020" "01/22/2020" ...
    ##  $ Province.State : chr  "Anhui" "Beijing" "Chongqing" "Fujian" ...
    ##  $ Country.Region : chr  "Mainland China" "Mainland China" "Mainland China" "Mainland China" ...
    ##  $ Last.Update    : chr  "1/22/2020 17:00" "1/22/2020 17:00" "1/22/2020 17:00" "1/22/2020 17:00" ...
    ##  $ Confirmed      : num  1 14 6 1 0 26 2 1 4 1 ...
    ##  $ Deaths         : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ Recovered      : num  0 0 0 0 0 0 0 0 0 0 ...

View data:

``` r
covid_data %>% sample_n(100) %>% as_tibble
```

    ## # A tibble: 100 x 8
    ##      SNo ObservationDate Province.State     Country.Region Last.Update    Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>              <chr>          <chr>              <dbl>  <dbl>     <dbl>
    ##  1   930 02/07/2020      Guizhou            Mainland China 2020-02-07T11…        81      1         6
    ##  2  2343 02/25/2020      <NA>               Philippines    2020-02-12T07…         3      1         1
    ##  3  3348 03/04/2020      Washington County… US             2020-03-03T03…         2      0         0
    ##  4   740 02/04/2020      Queensland         Australia      2020-02-04T16…         3      0         0
    ##  5  7577 03/21/2020      <NA>               Mauritania     2020-03-19T02…         2      0         0
    ##  6  3141 03/03/2020      <NA>               Vietnam        2020-02-25T08…        16      0        16
    ##  7  5066 03/12/2020      District of Colum… US             2020-03-11T22…        10      0         0
    ##  8  2374 02/25/2020      San Antonio, TX    US             2020-02-13T18…         1      0         0
    ##  9  3287 03/04/2020      King County, WA    US             2020-03-04T19…        31      9         1
    ## 10  4618 03/10/2020      <NA>               Azerbaijan     2020-03-10T16…        11      0         0
    ## # … with 90 more rows

## Preprocessing data

``` r
# repair names
names(covid_data) <- names(covid_data) %>% str_replace_all(fixed("."), "_") %>% str_to_lower

covid_data %<>% 
  rename(observation_date = observationdate) %>% 
  mutate(
    ## location processing
    province_state = str_trim(province_state),
    area = as.factor(
      case_when(
        province_state == "Hubei" ~ "Hubei",
        country_region == "US" ~ "US",
        str_detect(country_region, "China") ~ "China without Hubei",
        TRUE ~ "Rest of World")),
    
    ## dates processing
    observation_date = mdy(observation_date),
    last_update = parse_date_time(str_replace_all(last_update, "T", " "), 
                                  orders = c("%Y-%m-%d %H:%M:%S", "m/d/y %H:%M"))
  )
  

covid_data %>% as_tibble
```

    ## # A tibble: 7,926 x 9
    ##      sno observation_date province_state country_region last_update         confirmed deaths
    ##    <int> <date>           <chr>          <chr>          <dttm>                  <dbl>  <dbl>
    ##  1     1 2020-01-22       Anhui          Mainland China 2020-01-22 17:00:00         1      0
    ##  2     2 2020-01-22       Beijing        Mainland China 2020-01-22 17:00:00        14      0
    ##  3     3 2020-01-22       Chongqing      Mainland China 2020-01-22 17:00:00         6      0
    ##  4     4 2020-01-22       Fujian         Mainland China 2020-01-22 17:00:00         1      0
    ##  5     5 2020-01-22       Gansu          Mainland China 2020-01-22 17:00:00         0      0
    ##  6     6 2020-01-22       Guangdong      Mainland China 2020-01-22 17:00:00        26      0
    ##  7     7 2020-01-22       Guangxi        Mainland China 2020-01-22 17:00:00         2      0
    ##  8     8 2020-01-22       Guizhou        Mainland China 2020-01-22 17:00:00         1      0
    ##  9     9 2020-01-22       Hainan         Mainland China 2020-01-22 17:00:00         4      0
    ## 10    10 2020-01-22       Hebei          Mainland China 2020-01-22 17:00:00         1      0
    ## # … with 7,916 more rows, and 2 more variables: recovered <dbl>, area <fct>

Get data structure after preprocessing:

``` r
covid_data %>% skim_to_wide
```

    ## # A tibble: 9 x 20
    ##   type  variable missing complete n     min   max   empty n_unique median top_counts ordered mean 
    ##   <chr> <chr>    <chr>   <chr>    <chr> <chr> <chr> <chr> <chr>    <chr>  <chr>      <chr>   <chr>
    ## 1 char… country… 0       7926     7926  2     32    0     200      <NA>   <NA>       <NA>    <NA> 
    ## 2 char… provinc… 3436    4490     7926  2     43    0     280      <NA>   <NA>       <NA>    <NA> 
    ## 3 Date  observa… 0       7926     7926  2020… 2020… <NA>  61       2020-… <NA>       <NA>    <NA> 
    ## 4 fact… area     0       7926     7926  <NA>  <NA>  <NA>  4        <NA>   Res: 4420… FALSE   <NA> 
    ## 5 inte… sno      0       7926     7926  <NA>  <NA>  <NA>  <NA>     <NA>   <NA>       <NA>    3963…
    ## 6 nume… confirm… 0       7926     7926  <NA>  <NA>  <NA>  <NA>     <NA>   <NA>       <NA>    655.…
    ## 7 nume… deaths   0       7926     7926  <NA>  <NA>  <NA>  <NA>     <NA>   <NA>       <NA>    " 22…
    ## 8 nume… recover… 0       7926     7926  <NA>  <NA>  <NA>  <NA>     <NA>   <NA>       <NA>    237.…
    ## 9 POSI… last_up… 0       7926     7926  2020… 2020… <NA>  1860     2020-… <NA>       <NA>    <NA> 
    ## # … with 7 more variables: sd <chr>, p0 <chr>, p25 <chr>, p50 <chr>, p75 <chr>, p100 <chr>,
    ## #   hist <chr>

## COVID-19 spread

Get virus spread statistics grouped by `area`:

### Prepare data

Calculate total confirmed, deaths, and recovered cases:

``` r
spread_df <- covid_data %>% 
  group_by(
    area, observation_date
  ) %>% 
  summarise(
    confirmed_total = sum(confirmed),
    deaths_total = sum(deaths),
    recovered_total = sum(recovered)
  )

spread_df %>% arrange(desc(observation_date))
```

    ## # A tibble: 244 x 5
    ## # Groups:   area [4]
    ##    area                observation_date confirmed_total deaths_total recovered_total
    ##    <fct>               <date>                     <dbl>        <dbl>           <dbl>
    ##  1 China without Hubei 2020-03-22                 13260          117           12819
    ##  2 Hubei               2020-03-22                 67800         3144           59433
    ##  3 Rest of World       2020-03-22                221621        10956           25452
    ##  4 US                  2020-03-22                 33276          417             178
    ##  5 China without Hubei 2020-03-21                 13214          116           12803
    ##  6 Hubei               2020-03-21                 67800         3139           58946
    ##  7 Rest of World       2020-03-21                198021         9411           19756
    ##  8 US                  2020-03-21                 25493          307             171
    ##  9 China without Hubei 2020-03-20                 13177          116           12776
    ## 10 Hubei               2020-03-20                 67800         3133           58382
    ## # … with 234 more rows

### Visualize

``` r
ggplot(spread_df, aes(observation_date)) +
  
  geom_col(aes(y = confirmed_total), alpha = .5, fill = "grey") +
  geom_col(aes(y = recovered_total), alpha = .75, fill = "gold") +
  geom_col(aes(y = -deaths_total), alpha = .75, fill = "black") +

  scale_x_date(date_labels = "%d %b", date_breaks = "7 days") +
  scale_color_discrete(name = "Infected cases") +

  labs(x = "", y = "Number of cases", 
       title = "COVID-19 Spread", 
       subtitle = "Virus spread by Hubei, China (without Hubei), US, and Rest of World. \n* Grey - all confirmed cases; gold bar - all recovered cases; black bar - all deaths cases.", 
       caption = caption) +
  
  theme_minimal() +
  theme(legend.position = "top")
```

![](covid-19-data_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

## Dynamics of Infection

Get daily dynamics of the number of infected and recovered cases.

### Prepare data

``` r
covid_daily <- spread_df %>% 
  mutate_at(
    vars(ends_with("_total")),
    list("per_day" = ~ (. - lag(.)))
  ) %>% 
  ungroup() %>% 
  transmute(
    area, observation_date,
    retired_per_day = recovered_total_per_day + deaths_total_per_day,
    infected_per_day = confirmed_total_per_day
  ) %>% 
  mutate_at(
    vars(ends_with("_per_day")), 
    list(~ replace_na(., 0))
  )
  
covid_daily %>% 
  filter(area == "Hubei") %>% 
  arrange(desc(observation_date))
```

    ## # A tibble: 61 x 4
    ##    area  observation_date retired_per_day infected_per_day
    ##    <fct> <date>                     <dbl>            <dbl>
    ##  1 Hubei 2020-03-22                   492                0
    ##  2 Hubei 2020-03-21                   570                0
    ##  3 Hubei 2020-03-20                   703                0
    ##  4 Hubei 2020-03-19                   763                0
    ##  5 Hubei 2020-03-18                   935                1
    ##  6 Hubei 2020-03-17                   873                1
    ##  7 Hubei 2020-03-16                   868                4
    ##  8 Hubei 2020-03-15                  1338                4
    ##  9 Hubei 2020-03-14                  1420                4
    ## 10 Hubei 2020-03-13                  1241                5
    ## # … with 51 more rows

### Visualize

``` r
ggplot(covid_daily, aes(x = observation_date)) +
  geom_col(aes(y = -retired_per_day), fill = "gold", alpha = .7) +
  geom_col(aes(y = infected_per_day), fill = "black", alpha = .7) +
  geom_smooth(aes(y = infected_per_day - retired_per_day), method = "loess", color = "grey", alpha = .25) +
  
  facet_grid(area ~ ., scale = "free") +
  
  labs(title = "New COVID-19 Cases", 
       subtitle = "Daily dynamics by Hubei, China (without Hubei), US, and Rest of World. \n* Lines - active (infected minus healed and deaths) cases; gold bar - healed plus deaths cases; black bar - infected cases.", 
       x = "", y = "Number of cases per day",
       caption = caption) +
  
  theme_minimal()
```

![](covid-19-data_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

## Mortality rate

### Prepare data

``` r
mortality_df <- covid_data %>% 
  group_by(area, observation_date) %>% 
  summarise(
    confirmed_total = sum(confirmed),
    deaths_total = sum(deaths),
    recovered_total = sum(recovered)
  ) %>% 
  ungroup() %>% 
  inner_join(
    covid_data %>% 
      filter(deaths > 10) %>% 
      group_by(area) %>% 
      summarise(reference_date = min(observation_date)),
    by = "area"
  ) %>% 
  mutate(
    confirmed_deaths_rate = deaths_total/confirmed_total,
    recovered_deaths_rate = deaths_total/(recovered_total + deaths_total),
    n_days = observation_date %>% difftime(reference_date, units = "days") %>% as.numeric
  ) %>% 
  filter(n_days >= 0)


mortality_df %>% 
  filter(area == "US") %>% 
  arrange(desc(observation_date)) %>% 
  select(area, ends_with("_date"), recovered_total, contains("deaths_"))
```

    ## # A tibble: 17 x 7
    ##    area  observation_date reference_date recovered_total deaths_total confirmed_death…
    ##    <fct> <date>           <date>                   <dbl>        <dbl>            <dbl>
    ##  1 US    2020-03-22       2020-03-06                 178          417           0.0125
    ##  2 US    2020-03-21       2020-03-06                 171          307           0.0120
    ##  3 US    2020-03-20       2020-03-06                 147          244           0.0128
    ##  4 US    2020-03-19       2020-03-06                 108          200           0.0146
    ##  5 US    2020-03-18       2020-03-06                 106          118           0.0152
    ##  6 US    2020-03-17       2020-03-06                  17          108           0.0168
    ##  7 US    2020-03-16       2020-03-06                  17           85           0.0184
    ##  8 US    2020-03-15       2020-03-06                  12           63           0.0180
    ##  9 US    2020-03-14       2020-03-06                  12           54           0.0198
    ## 10 US    2020-03-13       2020-03-06                  12           47           0.0216
    ## 11 US    2020-03-12       2020-03-06                  12           40           0.0241
    ## 12 US    2020-03-11       2020-03-06                   8           36           0.0281
    ## 13 US    2020-03-10       2020-03-06                   8           28           0.0292
    ## 14 US    2020-03-09       2020-03-06                   8           22           0.0364
    ## 15 US    2020-03-08       2020-03-06                   8           21           0.0391
    ## 16 US    2020-03-07       2020-03-06                   8           17           0.0408
    ## 17 US    2020-03-06       2020-03-06                   8           14           0.0504
    ## # … with 1 more variable: recovered_deaths_rate <dbl>

### Visualize

``` r
ggplot(mortality_df, aes(x = n_days)) +
  geom_area(aes(y = recovered_deaths_rate), alpha = .75, fill = "gold") +
  geom_area(aes(y = confirmed_deaths_rate), alpha = .75, fill = "black") +
  
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  
  facet_grid(area ~ ., scales = "free") +
  
  labs(x = "Number of days since 10-th death case", y = "Mortality rate", 
       title = "COVID-19 Mortality Rate", 
       subtitle = "Rate by Hubei, China (without Hubei), US, and Rest of World. \n* Gold area - deaths to recovered cases ratio, grey area - deaths to confirmed cases ratio.", 
       caption = caption) +
  
  theme_minimal()
```

![](covid-19-data_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
ggplot(mortality_df, aes(x = n_days)) +
  geom_line(aes(y = confirmed_deaths_rate, color = area), size = 1, alpha = .75) +
  geom_hline(aes(yintercept = mean(mortality_df$confirmed_deaths_rate)), linetype = "dashed", color = "red", alpha = .75) +
  annotate(geom = "text", label = "Mean mortality rate (all time)", x = 4, y = mean(mortality_df$confirmed_deaths_rate), vjust = -1) +

  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  
  labs(x = "Number of days since 10-th death case", y = "Mortality rate", 
       title = "COVID-19 Mortality Rate", 
       subtitle = "Deaths to confirmed cases ratio by Hubei, China (without Hubei), US, and Rest of World", 
       caption = caption) +
  
  theme_minimal() +
  theme(legend.position = "top", 
        legend.title = element_blank())
```

![](covid-19-data_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
ggplot(mortality_df, aes(x = n_days)) +
  geom_line(aes(y = recovered_deaths_rate, color = area), size = 1, alpha = .75) +
  geom_hline(aes(yintercept = mean(mortality_df$recovered_deaths_rate)), linetype = "dashed", color = "red", alpha = .75) +
  annotate(geom = "text", label = "Mean mortality rate (all time)", x = 4, y = mean(mortality_df$confirmed_deaths_rate), vjust = -1) +

  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  
  labs(x = "Number of days since 10-th death case", y = "Mortality rate", 
       title = "COVID-19 Mortality Rate", 
       subtitle = "Deaths to recovered cases ratio by Hubei, China (without Hubei), US, and Rest of World", 
       caption = caption) +
  
  theme_minimal() +
  theme(legend.position = "top", 
        legend.title = element_blank())
```

![](covid-19-data_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->
