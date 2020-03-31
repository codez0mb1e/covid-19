COVID-19 Analytics
================
31 March, 2020

## Load dataset

Get list of files in datasets
    container:

    ## [1] "COVID19_line_list_data.csv"            "COVID19_open_line_list.csv"           
    ## [3] "covid_19_data.csv"                     "time_series_covid_19_confirmed.csv"   
    ## [5] "time_series_covid_19_confirmed_US.csv" "time_series_covid_19_deaths.csv"      
    ## [7] "time_series_covid_19_deaths_US.csv"    "time_series_covid_19_recovered.csv"

Load `covid_19_data.csv` dataset:

    ## # A tibble: 100 x 8
    ##      SNo ObservationDate Province.State   Country.Region Last.Update      Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>            <chr>          <chr>                <dbl>  <dbl>     <dbl>
    ##  1  2824 03/01/2020      Zhejiang         Mainland China 2020-03-01T10:1…      1205      1      1046
    ##  2  7292 03/20/2020      <NA>             Nicaragua      2020-03-19T08:3…         1      0         0
    ##  3  4125 03/08/2020      Pierce County, … US             2020-03-08T21:4…         4      0         0
    ##  4  9132 03/27/2020      <NA>             Belarus        2020-03-27 23:2…        94      0        32
    ##  5  4298 03/09/2020      Ningxia          Mainland China 2020-03-06T12:5…        75      0        71
    ##  6  5416 03/14/2020      California       US             2020-03-14T22:1…       340      5         6
    ##  7  4634 03/10/2020      <NA>             South Africa   2020-03-10T05:1…         7      0         0
    ##  8  5487 03/14/2020      <NA>             Peru           2020-03-14T12:3…        38      0         0
    ##  9  7027 03/20/2020      <NA>             Belgium        2020-03-20T14:4…      2257     37         1
    ## 10  1738 02/18/2020      Shanxi           Mainland China 2020-02-18T23:2…       131      0        61
    ## # … with 90 more rows

Get dataset structure:

    ## Skim summary statistics
    ##  n obs: 10358 
    ##  n variables: 8 
    ## 
    ## ── Variable type:character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##         variable missing complete     n min max empty n_unique
    ##   Country.Region       0    10358 10358   2  32     0      213
    ##      Last.Update       0    10358 10358  11  19     0     1813
    ##  ObservationDate       0    10358 10358  10  10     0       69
    ##   Province.State    4783     5575 10358   2  43     0      292
    ## 
    ## ── Variable type:integer ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n   mean      sd p0     p25    p50     p75  p100     hist
    ##       SNo       0    10358 10358 5179.5 2990.24  1 2590.25 5179.5 7768.75 10358 ▇▇▇▇▇▇▇▇
    ## 
    ## ── Variable type:numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##   variable missing complete     n   mean      sd p0 p25 p50 p75   p100     hist
    ##  Confirmed       0    10358 10358 941.07 6036.32  0   3  29 210 101739 ▇▁▁▁▁▁▁▁
    ##     Deaths       0    10358 10358  37.83  371.92  0   0   0   2  11591 ▇▁▁▁▁▁▁▁
    ##  Recovered       0    10358 10358 281.07 2972.77  0   0   0  13  62889 ▇▁▁▁▁▁▁▁

## Preprocessing data

Set `area` column, processing `province_state` columns, and format dates
columns:

    ## # A tibble: 10,358 x 4
    ##    area          country_region      province_state observation_date
    ##    <fct>         <chr>               <chr>          <date>          
    ##  1 Rest of World Afghanistan         <NA>           2020-03-30      
    ##  2 Rest of World Albania             <NA>           2020-03-30      
    ##  3 Rest of World Algeria             <NA>           2020-03-30      
    ##  4 Rest of World Andorra             <NA>           2020-03-30      
    ##  5 Rest of World Angola              <NA>           2020-03-30      
    ##  6 Rest of World Antigua and Barbuda <NA>           2020-03-30      
    ##  7 Rest of World Argentina           <NA>           2020-03-30      
    ##  8 Rest of World Armenia             <NA>           2020-03-30      
    ##  9 Rest of World Austria             <NA>           2020-03-30      
    ## 10 Rest of World Azerbaijan          <NA>           2020-03-30      
    ## # … with 10,348 more rows

Get dataset structure after preprocessing:

    ## Skim summary statistics
    ##  n obs: 10358 
    ##  n variables: 9 
    ## 
    ## ── Variable type:character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##        variable missing complete     n min max empty n_unique
    ##  country_region       0    10358 10358   2  32     0      213
    ##  province_state    4783     5575 10358   2  43     0      291
    ## 
    ## ── Variable type:Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##          variable missing complete     n        min        max     median n_unique
    ##  observation_date       0    10358 10358 2020-01-22 2020-03-30 2020-03-13       69
    ## 
    ## ── Variable type:factor ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n n_unique                              top_counts ordered
    ##      area       0    10358 10358        4 Res: 6129, US: 2092, Chi: 2068, Hub: 69   FALSE
    ## 
    ## ── Variable type:integer ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n   mean      sd p0     p25    p50     p75  p100     hist
    ##       sno       0    10358 10358 5179.5 2990.24  1 2590.25 5179.5 7768.75 10358 ▇▇▇▇▇▇▇▇
    ## 
    ## ── Variable type:numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##   variable missing complete     n   mean      sd p0 p25 p50 p75   p100     hist
    ##  confirmed       0    10358 10358 941.07 6036.32  0   3  29 210 101739 ▇▁▁▁▁▁▁▁
    ##     deaths       0    10358 10358  37.83  371.92  0   0   0   2  11591 ▇▁▁▁▁▁▁▁
    ##  recovered       0    10358 10358 281.07 2972.77  0   0   0  13  62889 ▇▁▁▁▁▁▁▁
    ## 
    ## ── Variable type:POSIXct ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##     variable missing complete     n        min        max     median n_unique
    ##  last_update       0    10358 10358 2020-01-22 2020-03-30 2020-03-11     1812

## COVID-19 spread

Get virus spread statistics grouped by `area`:

### Prepare data

Calculate total infected, recovered, and fatal cases:

    ## # A tibble: 276 x 5
    ## # Groups:   area [4]
    ##    area                  observation_date confirmed_total deaths_total recovered_total
    ##    <fct>                 <date>                     <dbl>        <dbl>           <dbl>
    ##  1 China (exclude Hubei) 2020-03-30                 13677          118           12901
    ##  2 Hubei                 2020-03-30                 67801         3186           62889
    ##  3 Rest of World         2020-03-30                539080        31300           83132
    ##  4 US                    2020-03-30                161807         2978            5644
    ##  5 China (exclude Hubei) 2020-03-29                 13643          118           12890
    ##  6 Hubei                 2020-03-29                 67801         3182           62570
    ##  7 Rest of World         2020-03-29                497787        28158           70957
    ##  8 US                    2020-03-29                140886         2467            2665
    ##  9 China (exclude Hubei) 2020-03-28                 13600          118           12880
    ## 10 Hubei                 2020-03-28                 67801         3177           62098
    ## # … with 266 more rows

### Visualize

Wordwide virus spread statistics:

    ## # A tibble: 69 x 4
    ##    observation_date confirmed_total deaths_total recovered_total
    ##    <date>                     <dbl>        <dbl>           <dbl>
    ##  1 2020-03-30                782365        37582          164566
    ##  2 2020-03-29                720117        33925          149082
    ##  3 2020-03-28                660706        30652          139415
    ##  4 2020-03-27                593291        27198          130915
    ##  5 2020-03-26                529591        23970          122150
    ##  6 2020-03-25                467594        21181          113770
    ##  7 2020-03-24                417966        18615          107705
    ##  8 2020-03-23                378287        16497          100958
    ##  9 2020-03-22                337020        14623           97243
    ## 10 2020-03-21                304528        12973           91676
    ## # … with 59 more rows

![](covid-19-eda_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

## Dynamics of Infection

Get daily dynamics of new infected and recovered cases.

### Prepare data

    ## # A tibble: 69 x 8
    ##    area  observation_date confirmed_total deaths_total recovered_total confirmed_total…
    ##    <fct> <date>                     <dbl>        <dbl>           <dbl>            <dbl>
    ##  1 Hubei 2020-03-30                 67801         3186           62889                0
    ##  2 Hubei 2020-03-29                 67801         3182           62570                0
    ##  3 Hubei 2020-03-28                 67801         3177           62098                0
    ##  4 Hubei 2020-03-27                 67801         3174           61732                0
    ##  5 Hubei 2020-03-26                 67801         3169           61201                0
    ##  6 Hubei 2020-03-25                 67801         3163           60811                0
    ##  7 Hubei 2020-03-24                 67801         3160           60324                1
    ##  8 Hubei 2020-03-23                 67800         3153           59882                0
    ##  9 Hubei 2020-03-22                 67800         3144           59433                0
    ## 10 Hubei 2020-03-21                 67800         3139           58946                0
    ## # … with 59 more rows, and 2 more variables: deaths_total_per_day <dbl>,
    ## #   recovered_total_per_day <dbl>

### Visualize

![](covid-19-eda_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

## Mortality rate

### Prepare data

    ## # A tibble: 25 x 7
    ##    area  observation_date reference_date recovered_total deaths_total confirmed_death…
    ##    <fct> <date>           <date>                   <dbl>        <dbl>            <dbl>
    ##  1 US    2020-03-30       2020-03-06                5644         2978           0.0184
    ##  2 US    2020-03-29       2020-03-06                2665         2467           0.0175
    ##  3 US    2020-03-28       2020-03-06                1072         2026           0.0167
    ##  4 US    2020-03-27       2020-03-06                 869         1581           0.0156
    ##  5 US    2020-03-26       2020-03-06                 681         1209           0.0144
    ##  6 US    2020-03-25       2020-03-06                 361          942           0.0143
    ##  7 US    2020-03-24       2020-03-06                 348          706           0.0131
    ##  8 US    2020-03-23       2020-03-06                   0          552           0.0126
    ##  9 US    2020-03-22       2020-03-06                   0          427           0.0127
    ## 10 US    2020-03-21       2020-03-06                 171          307           0.0120
    ## # … with 15 more rows, and 1 more variable: recovered_deaths_rate <dbl>

### Visualize

![](covid-19-eda_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

## World population

### Load world population

Get datasets
    list:

    ## [1] "metadata_country.csv"   "metadata_indicator.csv" "population_clean.csv"  
    ## [4] "population_raw.csv"

Load world population dataset:

    ## # A tibble: 61 x 17
    ##    type  variable missing complete n     min   max   empty n_unique mean  sd    p0    p25   p50  
    ##    <chr> <chr>    <chr>   <chr>    <chr> <chr> <chr> <chr> <chr>    <chr> <chr> <chr> <chr> <chr>
    ##  1 char… Country… 0       264      264   3     3     0     264      <NA>  <NA>  <NA>  <NA>  <NA> 
    ##  2 char… Country… 0       264      264   4     52    0     264      <NA>  <NA>  <NA>  <NA>  <NA> 
    ##  3 nume… X1960    4       260      264   <NA>  <NA>  <NA>  <NA>     "118… 3730… 3893  " 50… " 36…
    ##  4 nume… X1961    4       260      264   <NA>  <NA>  <NA>  <NA>     1196… 3775… 3989  " 51… " 37…
    ##  5 nume… X1962    4       260      264   <NA>  <NA>  <NA>  <NA>     1217… 3841… 4076  " 52… " 38…
    ##  6 nume… X1963    4       260      264   <NA>  <NA>  <NA>  <NA>     "124… 3926… 4183  " 53… " 39…
    ##  7 nume… X1964    4       260      264   <NA>  <NA>  <NA>  <NA>     "127… 4012… 4308  " 54… " 40…
    ##  8 nume… X1965    4       260      264   <NA>  <NA>  <NA>  <NA>     1297… "410… 4468  " 55… " 41…
    ##  9 nume… X1966    4       260      264   <NA>  <NA>  <NA>  <NA>     1326… 4195… 4685  " 56… " 42…
    ## 10 nume… X1967    4       260      264   <NA>  <NA>  <NA>  <NA>     1354… 4288… 4920  " 58… " 43…
    ## # … with 51 more rows, and 3 more variables: p75 <chr>, p100 <chr>, hist <chr>

Select relevant columns:

    ## # A tibble: 264 x 2
    ##    country                             n
    ##    <chr>                           <dbl>
    ##  1 World                      7594270356
    ##  2 IDA & IBRD total           6412522234
    ##  3 Low & middle income        6383958209
    ##  4 Middle income              5678540888
    ##  5 IBRD only                  4772284113
    ##  6 Early-demographic dividend 3249140605
    ##  7 Lower middle income        3022905169
    ##  8 Upper middle income        2655635719
    ##  9 East Asia & Pacific        2328220870
    ## 10 Late-demographic dividend  2288665963
    ## # … with 254 more rows

### Preprocessing

Get unmatched countries:

    ## # A tibble: 14 x 2
    ##    country_region         n
    ##    <chr>              <dbl>
    ##  1 Mainland China   4094720
    ##  2 US                899280
    ##  3 Iran              482959
    ##  4 South Korea       247232
    ##  5 UK                140245
    ##  6 Others             26228
    ##  7 Russia              9937
    ##  8 Hong Kong           8912
    ##  9 Egypt               6446
    ## 10 Diamond Princess    4272
    ## 11 Taiwan              4223
    ## 12 Slovakia            3077
    ## 13 Brunei              1559
    ## 14 Venezuela           1161

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 6 x 2
    ##   country_region       n
    ##   <chr>            <dbl>
    ## 1 Others           26228
    ## 2 Diamond Princess  4272
    ## 3 Taiwan            4223
    ## 4 Slovakia          3077
    ## 5 Brunei            1559
    ## 6 Venezuela         1161

Much better :)

## Enrich COVID dataset with world population

### Infected, recovered, fatal, and active cases

Calculate number of infected, recovered, fatal, and active cases grouped
by country:

View statistics in US:

    ## # A tibble: 69 x 10
    ##    country_region observation_date confirmed_total recovered_total deaths_total active_total
    ##    <chr>          <date>                     <dbl>           <dbl>        <dbl>        <dbl>
    ##  1 US             2020-03-30                161807            5644         2978       153185
    ##  2 US             2020-03-29                140886            2665         2467       135754
    ##  3 US             2020-03-28                121478            1072         2026       118380
    ##  4 US             2020-03-27                101657             869         1581        99207
    ##  5 US             2020-03-26                 83836             681         1209        81946
    ##  6 US             2020-03-25                 65778             361          942        64475
    ##  7 US             2020-03-24                 53740             348          706        52686
    ##  8 US             2020-03-23                 43667               0          552        43115
    ##  9 US             2020-03-22                 33746               0          427        33319
    ## 10 US             2020-03-21                 25493             171          307        25015
    ## # … with 59 more rows, and 4 more variables: first_confirmed_date <date>,
    ## #   n_days_since_1st_confirmed <dbl>, first_deaths_case_date <date>, n_days_since_1st_deaths <dbl>

View statistics in Russia:

    ## # A tibble: 60 x 10
    ##    country_region observation_date confirmed_total recovered_total deaths_total active_total
    ##    <chr>          <date>                     <dbl>           <dbl>        <dbl>        <dbl>
    ##  1 Russia         2020-03-30                  1836              66            9         1761
    ##  2 Russia         2020-03-29                  1534              64            8         1462
    ##  3 Russia         2020-03-28                  1264              49            4         1211
    ##  4 Russia         2020-03-27                  1036              45            4          987
    ##  5 Russia         2020-03-26                   840              38            3          799
    ##  6 Russia         2020-03-25                   658              29            3          626
    ##  7 Russia         2020-03-24                   495              22            1          472
    ##  8 Russia         2020-03-23                   438              17            1          420
    ##  9 Russia         2020-03-22                   367              16            1          350
    ## 10 Russia         2020-03-21                   306              12            1          293
    ## # … with 50 more rows, and 4 more variables: first_confirmed_date <date>,
    ## #   n_days_since_1st_confirmed <dbl>, first_deaths_case_date <date>, n_days_since_1st_deaths <dbl>

### Enrich COVID-19 dataset with world population

    ## # A tibble: 60 x 5
    ##    country_region n_days_since_1st_confirmed population_n confirmed_total confirmed_total_per_1M
    ##    <chr>                               <dbl>        <dbl>           <dbl>                  <dbl>
    ##  1 Russia                                 59    144478050            1836                  12.7 
    ##  2 Russia                                 58    144478050            1534                  10.6 
    ##  3 Russia                                 57    144478050            1264                   8.75
    ##  4 Russia                                 56    144478050            1036                   7.17
    ##  5 Russia                                 55    144478050             840                   5.81
    ##  6 Russia                                 54    144478050             658                   4.55
    ##  7 Russia                                 53    144478050             495                   3.43
    ##  8 Russia                                 52    144478050             438                   3.03
    ##  9 Russia                                 51    144478050             367                   2.54
    ## 10 Russia                                 50    144478050             306                   2.12
    ## # … with 50 more rows

### TOPs

Calculate countries stats whose populations were most affected by the
virus:

#### Top countries by infected cases

    ## # A tibble: 40 x 5
    ##    country_region population_n confirmed_total confirmed_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>           <dbl>                  <dbl>                      <dbl>
    ##  1 Spain              46723749           87956                  1882.                         58
    ##  2 Switzerland         8516543           15922                  1870.                         34
    ##  3 Italy              60431283          101739                  1684.                         59
    ##  4 Austria             8847037            9618                  1087.                         34
    ##  5 Belgium            11422068           11899                  1042.                         55
    ##  6 Norway              5314336            4445                   836.                         33
    ##  7 Germany            82927922           66885                   807.                         62
    ##  8 Netherlands        17231017           11817                   686.                         32
    ##  9 France             66987244           45170                   674.                         66
    ## 10 Portugal           10281762            6408                   623.                         28
    ## # … with 30 more rows

#### Top countries by active cases

    ## # A tibble: 40 x 5
    ##    country_region population_n active_total active_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>        <dbl>               <dbl>                      <dbl>
    ##  1 Switzerland         8516543        13740               1613.                         34
    ##  2 Spain              46723749        63460               1358.                         58
    ##  3 Italy              60431283        75528               1250.                         59
    ##  4 Austria             8847037         8874               1003.                         34
    ##  5 Belgium            11422068         9859                863.                         55
    ##  6 Norway              5314336         4401                828.                         33
    ##  7 Germany            82927922        52740                636.                         62
    ##  8 Netherlands        17231017        10699                621.                         32
    ##  9 Portugal           10281762         6225                605.                         28
    ## 10 Ireland             4853506         2851                587.                         30
    ## # … with 30 more rows

#### Top countries by fatal cases

    ## # A tibble: 40 x 5
    ##    country_region population_n deaths_total deaths_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>        <dbl>               <dbl>                      <dbl>
    ##  1 Italy              60431283        11591               192.                          59
    ##  2 Spain              46723749         7716               165.                          58
    ##  3 Netherlands        17231017          865                50.2                         32
    ##  4 France             66987244         3030                45.2                         66
    ##  5 Belgium            11422068          513                44.9                         55
    ##  6 Switzerland         8516543          359                42.2                         34
    ##  7 Iran               81800269         2757                33.7                         40
    ##  8 UK                 66488991         1411                21.2                         59
    ##  9 Sweden             10183175          146                14.3                         59
    ## 10 Portugal           10281762          140                13.6                         28
    ## # … with 30 more rows

#### Select countries to monitoring

Get top N
    countries:

    ##  [1] "Austria"        "Belgium"        "Germany"        "Ireland"        "Italy"         
    ##  [6] "Netherlands"    "Norway"         "Portugal"       "Spain"          "Switzerland"   
    ## [11] "US"             "Mainland China" "South Korea"    "Iran"

#### Active cases per 1M population vs number of days since 1st infected case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

#### Active cases per 1 million population vs number of days since 1st fatal case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->
