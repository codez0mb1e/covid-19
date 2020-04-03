COVID-19 Analytics
================
03 April, 2020

## Load COVID-19 data

Get list of files in datasets
    container:

    ## [1] "COVID19_line_list_data.csv"            "COVID19_open_line_list.csv"           
    ## [3] "covid_19_data.csv"                     "time_series_covid_19_confirmed.csv"   
    ## [5] "time_series_covid_19_confirmed_US.csv" "time_series_covid_19_deaths.csv"      
    ## [7] "time_series_covid_19_deaths_US.csv"    "time_series_covid_19_recovered.csv"

Load `covid_19_data.csv` dataset:

    ## # A tibble: 100 x 8
    ##      SNo ObservationDate Province.State Country.Region Last.Update        Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>          <chr>          <chr>                  <dbl>  <dbl>     <dbl>
    ##  1  4880 03/11/2020      <NA>           Lithuania      2020-03-11T02:18:…         3      0         0
    ##  2   108 01/24/2020      Taiwan         Taiwan         1/24/20 17:00              3      0         0
    ##  3   114 01/24/2020      Xinjiang       Mainland China 1/24/20 17:00              2      0         0
    ##  4  1923 02/20/2020      Chicago, IL    US             2020-02-09T19:03:…         2      0         2
    ##  5  2792 02/29/2020      <NA>           Georgia        2020-02-27T16:23:…         1      0         0
    ##  6  8310 03/24/2020      <NA>           Moldova        2020-03-24 23:41:…       125      1         2
    ##  7  9010 03/26/2020      Fujian         Mainland China 2020-03-26 23:53:…       328      1       295
    ##  8  4945 03/12/2020      Zhejiang       Mainland China 2020-03-12T01:33:…      1215      1      1197
    ##  9  5234 03/13/2020      <NA>           Turkey         2020-03-11T20:00:…         5      0         0
    ## 10  7988 03/23/2020      <NA>           Ireland        2020-03-23 23:23:…      1125      6         5
    ## # … with 90 more rows

## Preprocessing COVID-19 data

Set `area` column, processing `province_state` columns, and format dates
columns:

    ## # A tibble: 11,299 x 5
    ##    area          country_region province_state observation_date confirmed
    ##    <fct>         <chr>          <chr>          <date>               <dbl>
    ##  1 Rest of World Italy          <NA>           2020-04-02          115242
    ##  2 Rest of World Spain          <NA>           2020-04-02          112065
    ##  3 US            US             New York       2020-04-02           92506
    ##  4 Rest of World Germany        <NA>           2020-04-02           84794
    ##  5 Hubei         Mainland China Hubei          2020-04-02           67802
    ##  6 Rest of World France         <NA>           2020-04-02           59105
    ##  7 Rest of World Iran           <NA>           2020-04-02           50468
    ##  8 Rest of World UK             <NA>           2020-04-02           33718
    ##  9 US            US             New Jersey     2020-04-02           25590
    ## 10 Rest of World Switzerland    <NA>           2020-04-02           18827
    ## # … with 11,289 more rows

Get dataset structure after preprocessing:

    ## Skim summary statistics
    ##  n obs: 11299 
    ##  n variables: 9 
    ## 
    ## ── Variable type:character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##        variable missing complete     n min max empty n_unique
    ##  country_region       0    11299 11299   2  32     0      216
    ##  province_state    5312     5987 11299   2  43     0      292
    ## 
    ## ── Variable type:Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##          variable missing complete     n        min        max     median n_unique
    ##  observation_date       0    11299 11299 2020-01-22 2020-04-02 2020-03-15       72
    ## 
    ## ── Variable type:factor ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n n_unique                              top_counts ordered
    ##      area       0    11299 11299        4 Res: 6803, US: 2266, Chi: 2158, Hub: 72   FALSE
    ## 
    ## ── Variable type:integer ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n mean      sd p0    p25  p50    p75  p100     hist
    ##       sno       0    11299 11299 5650 3261.88  1 2825.5 5650 8474.5 11299 ▇▇▇▇▇▇▇▇
    ## 
    ## ── Variable type:numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##   variable missing complete     n    mean      sd p0 p25 p50 p75   p100     hist
    ##  confirmed       0    11299 11299 1110.79 6799.21  0   3  36 252 115242 ▇▁▁▁▁▁▁▁
    ##     deaths       0    11299 11299   47.24  457.81  0   0   0   2  13915 ▇▁▁▁▁▁▁▁
    ##  recovered       0    11299 11299  309.12 3096.96  0   0   0  16  63471 ▇▁▁▁▁▁▁▁
    ## 
    ## ── Variable type:POSIXct ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##     variable missing complete     n        min        max     median n_unique
    ##  last_update       0    11299 11299 2020-01-22 2020-04-02 2020-03-12     1815

## COVID-19 spread

Calculate total infected, recovered, and fatal cases:

### Wordwide spread

Last week statistics:

    ## # A tibble: 72 x 9
    ##    observation_date active_total active_total_de… confirmed_total confirmed_total… recovered_total
    ##    <date>                  <dbl> <chr>                      <dbl> <chr>                      <dbl>
    ##  1 2020-04-02             749911 8.27%                    1013157 8.64%                     210263
    ##  2 2020-04-01             692619 8.67%                     932605 8.76%                     193177
    ##  3 2020-03-31             637346 9.85%                     857487 9.60%                     178034
    ##  4 2020-03-30             580217 8.03%                     782365 8.64%                     164566
    ##  5 2020-03-29             537110 9.47%                     720117 8.99%                     149082
    ##  6 2020-03-28             490639 12.74%                    660706 11.36%                    139415
    ##  7 2020-03-27             435178 13.48%                    593291 12.03%                    130915
    ##  8 2020-03-26             383471 15.28%                    529591 13.26%                    122150
    ##  9 2020-03-25             332643 14.06%                    467594 11.87%                    113770
    ## 10 2020-03-24             291646 11.81%                    417966 10.49%                    107705
    ## # … with 62 more rows, and 3 more variables: recovered_total_delta <chr>, deaths_total <dbl>,
    ## #   deaths_total_delta <chr>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

### Spread by country

    ## # A tibble: 5,879 x 10
    ## # Groups:   country_region [216]
    ##    country_region observation_date active_total active_total_de… confirmed_total confirmed_total…
    ##    <chr>          <date>                  <dbl> <chr>                      <dbl> <chr>           
    ##  1 US             2020-04-02             228526 14.18%                    243453 14.10%          
    ##  2 Italy          2020-04-02              83049 3.07%                     115242 4.22%           
    ##  3 Spain          2020-04-02              74974 4.01%                     112065 7.63%           
    ##  4 Germany        2020-04-02              61247 5.14%                      84794 8.89%           
    ##  5 France         2020-04-02              41983 -1.57%                     59929 3.77%           
    ##  6 UK             2020-04-02              31055 13.63%                     34173 14.42%          
    ##  7 Iran           2020-04-02              30597 5.20%                      50468 6.04%           
    ##  8 Turkey         2020-04-02              17364 15.23%                     18135 15.66%          
    ##  9 Switzerland    2020-04-02              14278 -0.24%                     18827 5.96%           
    ## 10 Netherlands    2020-04-02              13187 7.55%                      14788 7.97%           
    ## # … with 5,869 more rows, and 4 more variables: recovered_total <dbl>, recovered_total_delta <chr>,
    ## #   deaths_total <dbl>, deaths_total_delta <chr>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

## COVID-19 daily spread

Get daily dynamics of new infected and recovered cases.

### World daily spread

    ## Selecting by active_total_per_day

    ## # A tibble: 7 x 9
    ##   observation_date confirmed_total deaths_total recovered_total active_total confirmed_total…
    ##   <date>                     <dbl>        <dbl>           <dbl>        <dbl>            <dbl>
    ## 1 2020-04-02               1013157        52983          210263       749911            80552
    ## 2 2020-04-01                932605        46809          193177       692619            75118
    ## 3 2020-03-31                857487        42107          178034       637346            75122
    ## 4 2020-03-29                720117        33925          149082       537110            59411
    ## 5 2020-03-28                660706        30652          139415       490639            67415
    ## 6 2020-03-27                593291        27198          130915       435178            63700
    ## 7 2020-03-26                529591        23970          122150       383471            61997
    ## # … with 3 more variables: deaths_total_per_day <dbl>, recovered_total_per_day <dbl>,
    ## #   active_total_per_day <dbl>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

### Countries daily spread

    ## # A tibble: 7 x 10
    ##   country_region observation_date confirmed_total deaths_total recovered_total active_total
    ##   <chr>          <date>                     <dbl>        <dbl>           <dbl>        <dbl>
    ## 1 India          2020-04-02                  2543           72             191         2280
    ## 2 India          2020-04-01                  1998           58             148         1792
    ## 3 India          2020-03-31                  1397           35             123         1239
    ## 4 India          2020-03-30                  1251           32             102         1117
    ## 5 India          2020-03-29                  1024           27              95          902
    ## 6 India          2020-03-28                   987           24              84          879
    ## 7 India          2020-03-27                   887           20              73          794
    ## # … with 4 more variables: confirmed_total_per_day <dbl>, deaths_total_per_day <dbl>,
    ## #   recovered_total_per_day <dbl>, active_total_per_day <dbl>

Top 5 countries with the largest number of infected
    people:

    ## Warning: Calling `as_tibble()` on a vector is discouraged, because the behavior is likely to change in the future. Use `tibble::enframe(name = NULL)` instead.
    ## This warning is displayed once per session.

    ## # A tibble: 5 x 1
    ##   value         
    ##   <chr>         
    ## 1 Germany       
    ## 2 Italy         
    ## 3 Mainland China
    ## 4 Spain         
    ## 5 US

![](covid-19-eda_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

## COVID-19 mortality rate

### Prepare data

    ## # A tibble: 28 x 7
    ##    area  observation_date reference_date recovered_total deaths_total confirmed_death…
    ##    <fct> <date>           <date>                   <dbl>        <dbl>            <dbl>
    ##  1 US    2020-04-02       2020-03-06                9001         5926           0.0243
    ##  2 US    2020-04-01       2020-03-06                8474         4757           0.0223
    ##  3 US    2020-03-31       2020-03-06                7024         3873           0.0206
    ##  4 US    2020-03-30       2020-03-06                5644         2978           0.0184
    ##  5 US    2020-03-29       2020-03-06                2665         2467           0.0175
    ##  6 US    2020-03-28       2020-03-06                1072         2026           0.0167
    ##  7 US    2020-03-27       2020-03-06                 869         1581           0.0156
    ##  8 US    2020-03-26       2020-03-06                 681         1209           0.0144
    ##  9 US    2020-03-25       2020-03-06                 361          942           0.0143
    ## 10 US    2020-03-24       2020-03-06                 348          706           0.0131
    ## # … with 18 more rows, and 1 more variable: recovered_deaths_rate <dbl>

### Visualize

![](covid-19-eda_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

## Enrich COVID dataset with world population

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

    ## # A tibble: 15 x 2
    ##    country_region         n
    ##    <chr>              <dbl>
    ##  1 Mainland China   4339388
    ##  2 US               1544277
    ##  3 Iran              625625
    ##  4 South Korea       276881
    ##  5 UK                229764
    ##  6 Others             26228
    ##  7 Russia             18599
    ##  8 Hong Kong          11193
    ##  9 Egypt               8800
    ## 10 Diamond Princess    6408
    ## 11 Taiwan              5213
    ## 12 Slovakia            4266
    ## 13 Brunei              1952
    ## 14 Venezuela           1585
    ## 15 Ivory Coast         1436

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 7 x 2
    ##   country_region       n
    ##   <chr>            <dbl>
    ## 1 Others           26228
    ## 2 Diamond Princess  6408
    ## 3 Taiwan            5213
    ## 4 Slovakia          4266
    ## 5 Brunei            1952
    ## 6 Venezuela         1585
    ## 7 Ivory Coast       1436

Much better :)

### Infected, recovered, fatal, and active cases

Calculate number of infected, recovered, fatal, and active (infected
cases minus recovered and fatal) cases grouped by country:

View statistics in US:

    ## # A tibble: 72 x 10
    ##    country_region observation_date confirmed_total recovered_total deaths_total active_total
    ##    <chr>          <date>                     <dbl>           <dbl>        <dbl>        <dbl>
    ##  1 US             2020-04-02                243453            9001         5926       228526
    ##  2 US             2020-04-01                213372            8474         4757       200141
    ##  3 US             2020-03-31                188172            7024         3873       177275
    ##  4 US             2020-03-30                161807            5644         2978       153185
    ##  5 US             2020-03-29                140886            2665         2467       135754
    ##  6 US             2020-03-28                121478            1072         2026       118380
    ##  7 US             2020-03-27                101657             869         1581        99207
    ##  8 US             2020-03-26                 83836             681         1209        81946
    ##  9 US             2020-03-25                 65778             361          942        64475
    ## 10 US             2020-03-24                 53740             348          706        52686
    ## # … with 62 more rows, and 4 more variables: first_confirmed_date <date>,
    ## #   n_days_since_1st_confirmed <dbl>, first_deaths_case_date <date>, n_days_since_1st_deaths <dbl>

View statistics in Russia:

    ## # A tibble: 63 x 10
    ##    country_region observation_date confirmed_total recovered_total deaths_total active_total
    ##    <chr>          <date>                     <dbl>           <dbl>        <dbl>        <dbl>
    ##  1 Russia         2020-04-02                  3548             235           30         3283
    ##  2 Russia         2020-04-01                  2777             190           24         2563
    ##  3 Russia         2020-03-31                  2337             121           17         2199
    ##  4 Russia         2020-03-30                  1836              66            9         1761
    ##  5 Russia         2020-03-29                  1534              64            8         1462
    ##  6 Russia         2020-03-28                  1264              49            4         1211
    ##  7 Russia         2020-03-27                  1036              45            4          987
    ##  8 Russia         2020-03-26                   840              38            3          799
    ##  9 Russia         2020-03-25                   658              29            3          626
    ## 10 Russia         2020-03-24                   495              22            1          472
    ## # … with 53 more rows, and 4 more variables: first_confirmed_date <date>,
    ## #   n_days_since_1st_confirmed <dbl>, first_deaths_case_date <date>, n_days_since_1st_deaths <dbl>

### Join COVID-19 dataset with world population

    ## # A tibble: 63 x 5
    ##    country_region n_days_since_1st_confirmed population_n confirmed_total confirmed_total_per_1M
    ##    <chr>                               <dbl>        <dbl>           <dbl>                  <dbl>
    ##  1 Russia                                 62    144478050            3548                  24.6 
    ##  2 Russia                                 61    144478050            2777                  19.2 
    ##  3 Russia                                 60    144478050            2337                  16.2 
    ##  4 Russia                                 59    144478050            1836                  12.7 
    ##  5 Russia                                 58    144478050            1534                  10.6 
    ##  6 Russia                                 57    144478050            1264                   8.75
    ##  7 Russia                                 56    144478050            1036                   7.17
    ##  8 Russia                                 55    144478050             840                   5.81
    ##  9 Russia                                 54    144478050             658                   4.55
    ## 10 Russia                                 53    144478050             495                   3.43
    ## # … with 53 more rows

### TOPs countries by infected, active, and fatal cases

Calculate countries stats whose populations were most affected by the
virus:

#### Top countries by infected cases

    ## # A tibble: 50 x 5
    ##    country_region population_n confirmed_total confirmed_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>           <dbl>                  <dbl>                      <dbl>
    ##  1 Spain              46723749          112065                  2398.                         61
    ##  2 Switzerland         8516543           18827                  2211.                         37
    ##  3 Italy              60431283          115242                  1907.                         62
    ##  4 Belgium            11422068           15348                  1344.                         58
    ##  5 Austria             8847037           11129                  1258.                         37
    ##  6 Germany            82927922           84794                  1023.                         65
    ##  7 Norway              5314336            5147                   969.                         36
    ##  8 France             66987244           59929                   895.                         69
    ##  9 Portugal           10281762            9034                   879.                         31
    ## 10 Netherlands        17231017           14788                   858.                         35
    ## # … with 40 more rows

#### Top countries by active cases

    ## # A tibble: 50 x 5
    ##    country_region population_n active_total active_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>        <dbl>               <dbl>                      <dbl>
    ##  1 Switzerland         8516543        14278               1677.                         37
    ##  2 Spain              46723749        74974               1605.                         61
    ##  3 Italy              60431283        83049               1374.                         62
    ##  4 Austria             8847037         9222               1042.                         37
    ##  5 Belgium            11422068        11842               1037.                         58
    ##  6 Norway              5314336         5065                953.                         36
    ##  7 Portugal           10281762         8757                852.                         31
    ##  8 Ireland             4853506         3746                772.                         33
    ##  9 Netherlands        17231017        13187                765.                         35
    ## 10 Germany            82927922        61247                739.                         65
    ## # … with 40 more rows

#### Top countries by fatal cases

    ## # A tibble: 50 x 5
    ##    country_region population_n deaths_total deaths_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>        <dbl>               <dbl>                      <dbl>
    ##  1 Italy              60431283        13915               230.                          62
    ##  2 Spain              46723749        10348               221.                          61
    ##  3 Belgium            11422068         1011                88.5                         58
    ##  4 France             66987244         5398                80.6                         69
    ##  5 Netherlands        17231017         1341                77.8                         35
    ##  6 Switzerland         8516543          536                62.9                         37
    ##  7 UK                 66488991         2926                44.0                         62
    ##  8 Iran               81800269         3160                38.6                         43
    ##  9 Sweden             10183175          308                30.2                         62
    ## 10 Denmark             5797446          123                21.2                         35
    ## # … with 40 more rows

#### Select countries to monitoring

Get top N
    countries:

    ##  [1] "Austria"        "Belgium"        "Germany"        "Ireland"        "Italy"         
    ##  [6] "Netherlands"    "Norway"         "Portugal"       "Spain"          "Switzerland"   
    ## [11] "US"             "Mainland China" "South Korea"    "Iran"

### Active cases per 1M population vs number of days since 1st infected case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

### Active cases per 1 million population vs number of days since 1st fatal case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->
