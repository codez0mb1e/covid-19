COVID-19 Analytics
================
26 March, 2020

## Load dataset

Get list of files in datasets
    container:

    ## [1] "COVID19_line_list_data.csv"         "COVID19_open_line_list.csv"        
    ## [3] "covid_19_data.csv"                  "time_series_covid_19_confirmed.csv"
    ## [5] "time_series_covid_19_deaths.csv"    "time_series_covid_19_recovered.csv"

Load `covid_19_data.csv` dataset:

    ## # A tibble: 100 x 8
    ##      SNo ObservationDate Province.State      Country.Region Last.Update   Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>               <chr>          <chr>             <dbl>  <dbl>     <dbl>
    ##  1  7932 03/23/2020      <NA>                Belize         2020-03-23 2…         1      0         0
    ##  2  6869 03/19/2020      <NA>                Moldova        2020-03-19T1…        49      1         1
    ##  3  8389 03/24/2020      Cayman Islands      UK             2020-03-24 2…         6      1         0
    ##  4  7960 03/23/2020      <NA>                Egypt          2020-03-23 2…       366     19        68
    ##  5  1655 02/17/2020      Shanghai            Mainland China 2020-02-17T2…       333      1       161
    ##  6  8323 03/24/2020      <NA>                North Macedon… 2020-03-24 2…       148      2         1
    ##  7  3171 03/03/2020      <NA>                Romania        2020-03-03T0…         3      0         0
    ##  8  5178 03/13/2020      Gansu               Mainland China 2020-03-13T1…       127      2        88
    ##  9  7550 03/21/2020      United States Virg… US             2020-03-21T1…         6      0         0
    ## 10  5271 03/13/2020      <NA>                Sudan          2020-03-11T2…         1      1         0
    ## # … with 90 more rows

Get dataset structure:

    ## 'data.frame':    8509 obs. of  8 variables:
    ##  $ SNo            : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ ObservationDate: chr  "01/22/2020" "01/22/2020" "01/22/2020" "01/22/2020" ...
    ##  $ Province.State : chr  "Anhui" "Beijing" "Chongqing" "Fujian" ...
    ##  $ Country.Region : chr  "Mainland China" "Mainland China" "Mainland China" "Mainland China" ...
    ##  $ Last.Update    : chr  "1/22/2020 17:00" "1/22/2020 17:00" "1/22/2020 17:00" "1/22/2020 17:00" ...
    ##  $ Confirmed      : num  1 14 6 1 0 26 2 1 4 1 ...
    ##  $ Deaths         : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ Recovered      : num  0 0 0 0 0 0 0 0 0 0 ...

## Preprocessing data

Set `area` column, processing `province_state` columns, and format dates
columns:

    ## # A tibble: 8,509 x 9
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
    ## # … with 8,499 more rows, and 2 more variables: recovered <dbl>, area <fct>

Get dataset structure after preprocessing:

    ## # A tibble: 9 x 20
    ##   type  variable missing complete n     min   max   empty n_unique median top_counts ordered mean 
    ##   <chr> <chr>    <chr>   <chr>    <chr> <chr> <chr> <chr> <chr>    <chr>  <chr>      <chr>   <chr>
    ## 1 char… country… 0       8509     8509  2     32    0     205      <NA>   <NA>       <NA>    <NA> 
    ## 2 char… provinc… 3751    4758     8509  2     43    0     287      <NA>   <NA>       <NA>    <NA> 
    ## 3 Date  observa… 0       8509     8509  2020… 2020… <NA>  63       2020-… <NA>       <NA>    <NA> 
    ## 4 fact… area     0       8509     8509  <NA>  <NA>  <NA>  4        <NA>   Res: 4820… FALSE   <NA> 
    ## 5 inte… sno      0       8509     8509  <NA>  <NA>  <NA>  <NA>     <NA>   <NA>       <NA>    4255 
    ## 6 nume… confirm… 0       8509     8509  <NA>  <NA>  <NA>  <NA>     <NA>   <NA>       <NA>    704.…
    ## 7 nume… deaths   0       8509     8509  <NA>  <NA>  <NA>  <NA>     <NA>   <NA>       <NA>    " 25…
    ## 8 nume… recover… 0       8509     8509  <NA>  <NA>  <NA>  <NA>     <NA>   <NA>       <NA>    245.…
    ## 9 POSI… last_up… 0       8509     8509  2020… 2020… <NA>  1806     2020-… <NA>       <NA>    <NA> 
    ## # … with 7 more variables: sd <chr>, p0 <chr>, p25 <chr>, p50 <chr>, p75 <chr>, p100 <chr>,
    ## #   hist <chr>

## COVID-19 spread

Get virus spread statistics grouped by `area`:

### Prepare data

Calculate total confirmed, deaths, and recovered cases:

    ## # A tibble: 252 x 6
    ## # Groups:   area [4]
    ##    area                observation_date confirmed_total deaths_total recovered_total active_total
    ##    <fct>               <date>                     <dbl>        <dbl>           <dbl>        <dbl>
    ##  1 China without Hubei 2020-03-24                 13379          117           12845          417
    ##  2 Hubei               2020-03-24                 67801         3160           60324         4317
    ##  3 Rest of World       2020-03-24                283046        14632           34188       234226
    ##  4 US                  2020-03-24                 53740          706             348        52686
    ##  5 China without Hubei 2020-03-23                 13316          117           12827          372
    ##  6 Hubei               2020-03-23                 67800         3153           59882         4765
    ##  7 Rest of World       2020-03-23                253504        12675           28249       212580
    ##  8 US                  2020-03-23                 43667          552               0        43115
    ##  9 China without Hubei 2020-03-22                 13260          117           12819          324
    ## 10 Hubei               2020-03-22                 67800         3144           59433         5223
    ## # … with 242 more rows

### Visualize

![](covid-19-data_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

## Dynamics of Infection

Get daily dynamics of new infected and recovered cases.

### Prepare data

    ## # A tibble: 63 x 4
    ##    area  observation_date retired_per_day infected_per_day
    ##    <fct> <date>                     <dbl>            <dbl>
    ##  1 Hubei 2020-03-24                   449                1
    ##  2 Hubei 2020-03-23                   458                0
    ##  3 Hubei 2020-03-22                   492                0
    ##  4 Hubei 2020-03-21                   570                0
    ##  5 Hubei 2020-03-20                   703                0
    ##  6 Hubei 2020-03-19                   763                0
    ##  7 Hubei 2020-03-18                   935                1
    ##  8 Hubei 2020-03-17                   873                1
    ##  9 Hubei 2020-03-16                   868                4
    ## 10 Hubei 2020-03-15                  1338                4
    ## # … with 53 more rows

### Visualize

![](covid-19-data_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

## Mortality rate

### Prepare data

    ## # A tibble: 19 x 7
    ##    area  observation_date reference_date recovered_total deaths_total confirmed_death…
    ##    <fct> <date>           <date>                   <dbl>        <dbl>            <dbl>
    ##  1 US    2020-03-24       2020-03-06                 348          706           0.0131
    ##  2 US    2020-03-23       2020-03-06                   0          552           0.0126
    ##  3 US    2020-03-22       2020-03-06                   0          427           0.0127
    ##  4 US    2020-03-21       2020-03-06                 171          307           0.0120
    ##  5 US    2020-03-20       2020-03-06                 147          244           0.0128
    ##  6 US    2020-03-19       2020-03-06                 108          200           0.0146
    ##  7 US    2020-03-18       2020-03-06                 106          118           0.0152
    ##  8 US    2020-03-17       2020-03-06                  17          108           0.0168
    ##  9 US    2020-03-16       2020-03-06                  17           85           0.0184
    ## 10 US    2020-03-15       2020-03-06                  12           63           0.0180
    ## 11 US    2020-03-14       2020-03-06                  12           54           0.0198
    ## 12 US    2020-03-13       2020-03-06                  12           47           0.0216
    ## 13 US    2020-03-12       2020-03-06                  12           40           0.0241
    ## 14 US    2020-03-11       2020-03-06                   8           36           0.0281
    ## 15 US    2020-03-10       2020-03-06                   8           28           0.0292
    ## 16 US    2020-03-09       2020-03-06                   8           22           0.0364
    ## 17 US    2020-03-08       2020-03-06                   8           21           0.0391
    ## 18 US    2020-03-07       2020-03-06                   8           17           0.0408
    ## 19 US    2020-03-06       2020-03-06                   8           14           0.0504
    ## # … with 1 more variable: recovered_deaths_rate <dbl>

### Visualize

![](covid-19-data_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

![](covid-19-data_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

![](covid-19-data_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->
