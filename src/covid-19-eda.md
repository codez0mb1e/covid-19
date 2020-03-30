COVID-19 Analytics
================
30 March, 2020

## Load dataset

Get list of files in datasets
    container:

    ## [1] "COVID19_line_list_data.csv"         "COVID19_open_line_list.csv"        
    ## [3] "covid_19_data.csv"                  "time_series_covid_19_confirmed.csv"
    ## [5] "time_series_covid_19_deaths.csv"    "time_series_covid_19_recovered.csv"

Load `covid_19_data.csv` dataset:

    ## # A tibble: 100 x 8
    ##      SNo ObservationDate Province.State    Country.Region  Last.Update    Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>             <chr>           <chr>              <dbl>  <dbl>     <dbl>
    ##  1  2655 02/28/2020      <NA>              Finland         2020-02-26T19…         2      0         1
    ##  2  9462 03/28/2020      <NA>              Cuba            2020-03-28 23…       119      3         4
    ##  3  5754 03/15/2020      Ohio              US              2020-03-15T18…        37      0         0
    ##  4   801 02/05/2020      <NA>              Germany         2020-02-03T20…        12      0         0
    ##  5  4101 03/08/2020      Middlesex County… US              2020-03-08T21…         7      0         0
    ##  6  8927 03/26/2020      <NA>              Nigeria         2020-03-26 23…        65      1         2
    ##  7  7508 03/21/2020      <NA>              Nigeria         2020-03-21T15…        22      0         1
    ##  8  7450 03/21/2020      <NA>              Andorra         2020-03-21T15…        88      0         1
    ##  9  3532 03/05/2020      <NA>              Latvia          2020-03-04T01…         1      0         0
    ## 10  5583 03/14/2020      <NA>              Congo (Kinshas… 2020-03-13T22…         2      0         0
    ## # … with 90 more rows

Get dataset structure:

    ## Skim summary statistics
    ##  n obs: 10046 
    ##  n variables: 8 
    ## 
    ## ── Variable type:character ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##         variable missing complete     n min max empty n_unique
    ##   Country.Region       0    10046 10046   2  32     0      212
    ##      Last.Update       0    10046 10046  11  19     0     1812
    ##  ObservationDate       0    10046 10046  10  10     0       68
    ##   Province.State    4609     5437 10046   2  43     0      292
    ## 
    ## ── Variable type:integer ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n   mean      sd p0     p25    p50     p75  p100     hist
    ##       SNo       0    10046 10046 5023.5 2900.17  1 2512.25 5023.5 7534.75 10046 ▇▇▇▇▇▇▇▇
    ## 
    ## ── Variable type:numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##   variable missing complete     n   mean      sd p0 p25 p50 p75  p100     hist
    ##  Confirmed       0    10046 10046 892.42 5827.26  0   3  27 195 97689 ▇▁▁▁▁▁▁▁
    ##     Deaths       0    10046 10046  35.26  346.89  0   0   0   2 10779 ▇▁▁▁▁▁▁▁
    ##  Recovered       0    10046 10046 273.42 2936.69  0   0   0  12 62570 ▇▁▁▁▁▁▁▁

## Preprocessing data

Set `area` column, processing `province_state` columns, and format dates
columns:

    ## # A tibble: 10,046 x 4
    ##    area          country_region      province_state observation_date
    ##    <fct>         <chr>               <chr>          <date>          
    ##  1 Rest of World Afghanistan         <NA>           2020-03-29      
    ##  2 Rest of World Albania             <NA>           2020-03-29      
    ##  3 Rest of World Algeria             <NA>           2020-03-29      
    ##  4 Rest of World Andorra             <NA>           2020-03-29      
    ##  5 Rest of World Angola              <NA>           2020-03-29      
    ##  6 Rest of World Antigua and Barbuda <NA>           2020-03-29      
    ##  7 Rest of World Argentina           <NA>           2020-03-29      
    ##  8 Rest of World Armenia             <NA>           2020-03-29      
    ##  9 Rest of World Austria             <NA>           2020-03-29      
    ## 10 Rest of World Azerbaijan          <NA>           2020-03-29      
    ## # … with 10,036 more rows

Get dataset structure after preprocessing:

    ## Skim summary statistics
    ##  n obs: 10046 
    ##  n variables: 9 
    ## 
    ## ── Variable type:character ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##        variable missing complete     n min max empty n_unique
    ##  country_region       0    10046 10046   2  32     0      212
    ##  province_state    4609     5437 10046   2  43     0      291
    ## 
    ## ── Variable type:Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##          variable missing complete     n        min        max     median n_unique
    ##  observation_date       0    10046 10046 2020-01-22 2020-03-29 2020-03-12       68
    ## 
    ## ── Variable type:factor ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n n_unique                              top_counts ordered
    ##      area       0    10046 10046        4 Res: 5907, Chi: 2038, US: 2033, Hub: 68   FALSE
    ## 
    ## ── Variable type:integer ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n   mean      sd p0     p25    p50     p75  p100     hist
    ##       sno       0    10046 10046 5023.5 2900.17  1 2512.25 5023.5 7534.75 10046 ▇▇▇▇▇▇▇▇
    ## 
    ## ── Variable type:numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##   variable missing complete     n   mean      sd p0 p25 p50 p75  p100     hist
    ##  confirmed       0    10046 10046 892.42 5827.26  0   3  27 195 97689 ▇▁▁▁▁▁▁▁
    ##     deaths       0    10046 10046  35.26  346.89  0   0   0   2 10779 ▇▁▁▁▁▁▁▁
    ##  recovered       0    10046 10046 273.42 2936.69  0   0   0  12 62570 ▇▁▁▁▁▁▁▁
    ## 
    ## ── Variable type:POSIXct ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##     variable missing complete     n        min        max     median n_unique
    ##  last_update       0    10046 10046 2020-01-22 2020-03-29 2020-03-10     1811

## COVID-19 spread

Get virus spread statistics grouped by `area`:

### Prepare data

Calculate total infected, recovered, and fatal cases:

    ## # A tibble: 272 x 5
    ## # Groups:   area [4]
    ##    area                  observation_date confirmed_total deaths_total recovered_total
    ##    <fct>                 <date>                     <dbl>        <dbl>           <dbl>
    ##  1 China (exclude Hubei) 2020-03-29                 13643          118           12890
    ##  2 Hubei                 2020-03-29                 67801         3182           62570
    ##  3 Rest of World         2020-03-29                497787        28158           70957
    ##  4 US                    2020-03-29                140886         2467            2665
    ##  5 China (exclude Hubei) 2020-03-28                 13600          118           12880
    ##  6 Hubei                 2020-03-28                 67801         3177           62098
    ##  7 Rest of World         2020-03-28                457827        25331           63365
    ##  8 US                    2020-03-28                121478         2026            1072
    ##  9 China (exclude Hubei) 2020-03-27                 13544          118           12868
    ## 10 Hubei                 2020-03-27                 67801         3174           61732
    ## # … with 262 more rows

### Visualize

Wordwide virus spread statistics:

    ## # A tibble: 68 x 4
    ##    observation_date confirmed_total deaths_total recovered_total
    ##    <date>                     <dbl>        <dbl>           <dbl>
    ##  1 2020-03-29                720117        33925          149082
    ##  2 2020-03-28                660706        30652          139415
    ##  3 2020-03-27                593291        27198          130915
    ##  4 2020-03-26                529591        23970          122150
    ##  5 2020-03-25                467594        21181          113770
    ##  6 2020-03-24                417966        18615          107705
    ##  7 2020-03-23                378287        16497          100958
    ##  8 2020-03-22                337020        14623           97243
    ##  9 2020-03-21                304528        12973           91676
    ## 10 2020-03-20                272167        11299           87403
    ## # … with 58 more rows

![](covid-19-eda_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

## Dynamics of Infection

Get daily dynamics of new infected and recovered cases.

### Prepare data

    ## # A tibble: 68 x 8
    ##    area  observation_date confirmed_total deaths_total recovered_total confirmed_total…
    ##    <fct> <date>                     <dbl>        <dbl>           <dbl>            <dbl>
    ##  1 Hubei 2020-03-29                 67801         3182           62570                0
    ##  2 Hubei 2020-03-28                 67801         3177           62098                0
    ##  3 Hubei 2020-03-27                 67801         3174           61732                0
    ##  4 Hubei 2020-03-26                 67801         3169           61201                0
    ##  5 Hubei 2020-03-25                 67801         3163           60811                0
    ##  6 Hubei 2020-03-24                 67801         3160           60324                1
    ##  7 Hubei 2020-03-23                 67800         3153           59882                0
    ##  8 Hubei 2020-03-22                 67800         3144           59433                0
    ##  9 Hubei 2020-03-21                 67800         3139           58946                0
    ## 10 Hubei 2020-03-20                 67800         3133           58382                0
    ## # … with 58 more rows, and 2 more variables: deaths_total_per_day <dbl>,
    ## #   recovered_total_per_day <dbl>

### Visualize

![](covid-19-eda_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

## Mortality rate

### Prepare data

    ## # A tibble: 24 x 7
    ##    area  observation_date reference_date recovered_total deaths_total confirmed_death…
    ##    <fct> <date>           <date>                   <dbl>        <dbl>            <dbl>
    ##  1 US    2020-03-29       2020-03-06                2665         2467           0.0175
    ##  2 US    2020-03-28       2020-03-06                1072         2026           0.0167
    ##  3 US    2020-03-27       2020-03-06                 869         1581           0.0156
    ##  4 US    2020-03-26       2020-03-06                 681         1209           0.0144
    ##  5 US    2020-03-25       2020-03-06                 361          942           0.0143
    ##  6 US    2020-03-24       2020-03-06                 348          706           0.0131
    ##  7 US    2020-03-23       2020-03-06                   0          552           0.0126
    ##  8 US    2020-03-22       2020-03-06                   0          427           0.0127
    ##  9 US    2020-03-21       2020-03-06                 171          307           0.0120
    ## 10 US    2020-03-20       2020-03-06                 147          244           0.0128
    ## # … with 14 more rows, and 1 more variable: recovered_deaths_rate <dbl>

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
    ##  1 Mainland China   4013242
    ##  2 US                737473
    ##  3 Iran              441464
    ##  4 South Korea       237571
    ##  5 UK                117792
    ##  6 Others             26228
    ##  7 Hong Kong           8230
    ##  8 Russia              8101
    ##  9 Egypt               5790
    ## 10 Taiwan              3917
    ## 11 Diamond Princess    3560
    ## 12 Slovakia            2741
    ## 13 Brunei              1432
    ## 14 Venezuela           1026

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 6 x 2
    ##   country_region       n
    ##   <chr>            <dbl>
    ## 1 Others           26228
    ## 2 Taiwan            3917
    ## 3 Diamond Princess  3560
    ## 4 Slovakia          2741
    ## 5 Brunei            1432
    ## 6 Venezuela         1026

Much better :)

## Enrich COVID dataset with world population

### Infected, recovered, fatal, and active cases

Calculate number of infected, recovered, fatal, and active cases grouped
by country:

View statistics in US:

    ## # A tibble: 68 x 10
    ##    country_region observation_date confirmed_total recovered_total deaths_total active_total
    ##    <chr>          <date>                     <dbl>           <dbl>        <dbl>        <dbl>
    ##  1 US             2020-03-29                140886            2665         2467       135754
    ##  2 US             2020-03-28                121478            1072         2026       118380
    ##  3 US             2020-03-27                101657             869         1581        99207
    ##  4 US             2020-03-26                 83836             681         1209        81946
    ##  5 US             2020-03-25                 65778             361          942        64475
    ##  6 US             2020-03-24                 53740             348          706        52686
    ##  7 US             2020-03-23                 43667               0          552        43115
    ##  8 US             2020-03-22                 33746               0          427        33319
    ##  9 US             2020-03-21                 25493             171          307        25015
    ## 10 US             2020-03-20                 19101             147          244        18710
    ## # … with 58 more rows, and 4 more variables: first_confirmed_date <date>,
    ## #   n_days_since_1st_confirmed <dbl>, first_deaths_case_date <date>, n_days_since_1st_deaths <dbl>

View statistics in Russia:

    ## # A tibble: 59 x 10
    ##    country_region observation_date confirmed_total recovered_total deaths_total active_total
    ##    <chr>          <date>                     <dbl>           <dbl>        <dbl>        <dbl>
    ##  1 Russia         2020-03-29                  1534              64            8         1462
    ##  2 Russia         2020-03-28                  1264              49            4         1211
    ##  3 Russia         2020-03-27                  1036              45            4          987
    ##  4 Russia         2020-03-26                   840              38            3          799
    ##  5 Russia         2020-03-25                   658              29            3          626
    ##  6 Russia         2020-03-24                   495              22            1          472
    ##  7 Russia         2020-03-23                   438              17            1          420
    ##  8 Russia         2020-03-22                   367              16            1          350
    ##  9 Russia         2020-03-21                   306              12            1          293
    ## 10 Russia         2020-03-20                   253               9            1          243
    ## # … with 49 more rows, and 4 more variables: first_confirmed_date <date>,
    ## #   n_days_since_1st_confirmed <dbl>, first_deaths_case_date <date>, n_days_since_1st_deaths <dbl>

### Enrich COVID-19 dataset with world population

    ## # A tibble: 59 x 5
    ##    country_region n_days_since_1st_confirmed population_n confirmed_total confirmed_total_per_1M
    ##    <chr>                               <dbl>        <dbl>           <dbl>                  <dbl>
    ##  1 Russia                                 58    144478050            1534                  10.6 
    ##  2 Russia                                 57    144478050            1264                   8.75
    ##  3 Russia                                 56    144478050            1036                   7.17
    ##  4 Russia                                 55    144478050             840                   5.81
    ##  5 Russia                                 54    144478050             658                   4.55
    ##  6 Russia                                 53    144478050             495                   3.43
    ##  7 Russia                                 52    144478050             438                   3.03
    ##  8 Russia                                 51    144478050             367                   2.54
    ##  9 Russia                                 50    144478050             306                   2.12
    ## 10 Russia                                 49    144478050             253                   1.75
    ## # … with 49 more rows

### TOPs

Calculate countries stats whose populations were most affected by the
virus:

#### Top countries by infected cases

    ## # A tibble: 40 x 5
    ##    country_region population_n confirmed_total confirmed_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>           <dbl>                  <dbl>                      <dbl>
    ##  1 Switzerland         8516543           14829                  1741.                         33
    ##  2 Spain              46723749           80110                  1715.                         57
    ##  3 Italy              60431283           97689                  1617.                         58
    ##  4 Austria             8847037            8788                   993.                         33
    ##  5 Belgium            11422068           10836                   949.                         54
    ##  6 Norway              5314336            4284                   806.                         32
    ##  7 Germany            82927922           62095                   749.                         61
    ##  8 Netherlands        17231017           10930                   634.                         31
    ##  9 France             66987244           40708                   608.                         65
    ## 10 Portugal           10281762            5962                   580.                         27
    ## # … with 30 more rows

#### Top countries by active cases

    ## # A tibble: 40 x 5
    ##    country_region population_n active_total active_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>        <dbl>               <dbl>                      <dbl>
    ##  1 Switzerland         8516543        12934               1519.                         33
    ##  2 Spain              46723749        58598               1254.                         57
    ##  3 Italy              60431283        73880               1223.                         58
    ##  4 Austria             8847037         8223                929.                         33
    ##  5 Norway              5314336         4252                800.                         32
    ##  6 Belgium            11422068         9046                792.                         54
    ##  7 Germany            82927922        52351                631.                         61
    ##  8 Netherlands        17231017         9905                575.                         31
    ##  9 Portugal           10281762         5800                564.                         27
    ## 10 Ireland             4853506         2564                528.                         29
    ## # … with 30 more rows

#### Top countries by fatal cases

    ## # A tibble: 40 x 5
    ##    country_region population_n deaths_total deaths_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>        <dbl>               <dbl>                      <dbl>
    ##  1 Italy              60431283        10779               178.                          58
    ##  2 Spain              46723749         6803               146.                          57
    ##  3 Netherlands        17231017          772                44.8                         31
    ##  4 France             66987244         2611                39.0                         65
    ##  5 Belgium            11422068          431                37.7                         54
    ##  6 Switzerland         8516543          300                35.2                         33
    ##  7 Iran               81800269         2640                32.3                         39
    ##  8 UK                 66488991         1231                18.5                         58
    ##  9 Denmark             5797446           72                12.4                         31
    ## 10 Portugal           10281762          119                11.6                         27
    ## # … with 30 more rows

#### Select countries to monitoring

Get top N
    countries:

    ##  [1] "Austria"        "Belgium"        "Germany"        "Ireland"        "Italy"         
    ##  [6] "Netherlands"    "Norway"         "Portugal"       "Spain"          "Switzerland"   
    ## [11] "US"             "India"          "Mainland China" "South Korea"    "Japan"         
    ## [16] "Iran"

#### Active cases per 1M population vs number of days since 1st infected case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

#### Active cases per 1 million population vs number of days since 1st fatal case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->
