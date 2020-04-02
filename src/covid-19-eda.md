COVID-19 Analytics
================
02 April, 2020

## Load COVID-19 data

Get list of files in datasets
    container:

    ## [1] "COVID19_line_list_data.csv"            "COVID19_open_line_list.csv"           
    ## [3] "covid_19_data.csv"                     "time_series_covid_19_confirmed.csv"   
    ## [5] "time_series_covid_19_confirmed_US.csv" "time_series_covid_19_deaths.csv"      
    ## [7] "time_series_covid_19_deaths_US.csv"    "time_series_covid_19_recovered.csv"

Load `covid_19_data.csv` dataset:

    ## # A tibble: 100 x 8
    ##      SNo ObservationDate Province.State      Country.Region Last.Update   Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>               <chr>          <chr>             <dbl>  <dbl>     <dbl>
    ##  1  2451 02/26/2020      San Diego County, … US             2020-02-21T0…         2      0         1
    ##  2  2942 03/01/2020      Omaha, NE (From Di… US             2020-02-24T2…         0      0         0
    ##  3  5202 03/13/2020      <NA>                Thailand       2020-03-11T2…        75      1        35
    ##  4  9521 03/28/2020      <NA>                MS Zaandam     2020-03-28 2…         2      0         0
    ##  5  5600 03/14/2020      <NA>                Bhutan         2020-03-13T2…         1      0         0
    ##  6  1527 02/15/2020      Qinghai             Mainland China 2020-02-15T0…        18      0        13
    ##  7  9376 03/27/2020      Northern Mariana I… US             2020-03-27 2…         0      0         0
    ##  8  7398 03/21/2020      <NA>                South Africa   2020-03-21T1…       240      0         0
    ##  9  5062 03/12/2020      <NA>                Brunei         2020-03-11T2…        11      0         0
    ## 10  9573 03/28/2020      <NA>                Sri Lanka      2020-03-28 2…       113      1         9
    ## # … with 90 more rows

## Preprocessing COVID-19 data

Set `area` column, processing `province_state` columns, and format dates
columns:

    ## # A tibble: 10,984 x 5
    ##    area          country_region province_state observation_date confirmed
    ##    <fct>         <chr>          <chr>          <date>               <dbl>
    ##  1 Rest of World Italy          <NA>           2020-04-01          110574
    ##  2 Rest of World Spain          <NA>           2020-04-01          104118
    ##  3 US            US             New York       2020-04-01           83948
    ##  4 Rest of World Germany        <NA>           2020-04-01           77872
    ##  5 Hubei         Mainland China Hubei          2020-04-01           67802
    ##  6 Rest of World France         <NA>           2020-04-01           56989
    ##  7 Rest of World Iran           <NA>           2020-04-01           47593
    ##  8 Rest of World UK             <NA>           2020-04-01           29474
    ##  9 US            US             New Jersey     2020-04-01           22255
    ## 10 Rest of World Switzerland    <NA>           2020-04-01           17768
    ## # … with 10,974 more rows

Get dataset structure after preprocessing:

    ## Skim summary statistics
    ##  n obs: 10984 
    ##  n variables: 9 
    ## 
    ## ── Variable type:character ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##        variable missing complete     n min max empty n_unique
    ##  country_region       0    10984 10984   2  32     0      215
    ##  province_state    5135     5849 10984   2  43     0      291
    ## 
    ## ── Variable type:Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##          variable missing complete     n        min        max     median n_unique
    ##  observation_date       0    10984 10984 2020-01-22 2020-04-01 2020-03-14       71
    ## 
    ## ── Variable type:factor ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n n_unique                              top_counts ordered
    ##      area       0    10984 10984        4 Res: 6577, US: 2208, Chi: 2128, Hub: 71   FALSE
    ## 
    ## ── Variable type:integer ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  variable missing complete     n   mean      sd p0     p25    p50     p75  p100     hist
    ##       sno       0    10984 10984 5492.5 3170.95  1 2746.75 5492.5 8238.25 10984 ▇▇▇▇▇▇▇▇
    ## 
    ## ── Variable type:numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##   variable missing complete     n    mean      sd p0 p25 p50 p75   p100     hist
    ##  confirmed       0    10984 10984 1050.41 6524.12  0   3  33 245 110574 ▇▁▁▁▁▁▁▁
    ##     deaths       0    10984 10984   43.77  426.97  0   0   0   2  13155 ▇▁▁▁▁▁▁▁
    ##  recovered       0    10984 10984  298.85 3051.74  0   0   0  15  63326 ▇▁▁▁▁▁▁▁
    ## 
    ## ── Variable type:POSIXct ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##     variable missing complete     n        min        max     median n_unique
    ##  last_update       0    10984 10984 2020-01-22 2020-04-01 2020-03-11     1814

## COVID-19 spread

Calculate total infected, recovered, and fatal cases:

### Wordwide spread

Last week statistics:

    ## # A tibble: 71 x 9
    ##    observation_date active_total active_total_de… confirmed_total confirmed_total… recovered_total
    ##    <date>                  <dbl> <chr>                      <dbl> <chr>                      <dbl>
    ##  1 2020-04-01             692619 8.67%                     932605 8.76%                     193177
    ##  2 2020-03-31             637346 9.85%                     857487 9.60%                     178034
    ##  3 2020-03-30             580217 8.03%                     782365 8.64%                     164566
    ##  4 2020-03-29             537110 9.47%                     720117 8.99%                     149082
    ##  5 2020-03-28             490639 12.74%                    660706 11.36%                    139415
    ##  6 2020-03-27             435178 13.48%                    593291 12.03%                    130915
    ##  7 2020-03-26             383471 15.28%                    529591 13.26%                    122150
    ##  8 2020-03-25             332643 14.06%                    467594 11.87%                    113770
    ##  9 2020-03-24             291646 11.81%                    417966 10.49%                    107705
    ## 10 2020-03-23             260832 15.85%                    378287 12.24%                    100958
    ## # … with 61 more rows, and 3 more variables: recovered_total_delta <chr>, deaths_total <dbl>,
    ## #   deaths_total_delta <chr>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

### Spread by country

    ## # A tibble: 5,696 x 10
    ## # Groups:   country_region [215]
    ##    country_region observation_date active_total active_total_de… confirmed_total confirmed_total…
    ##    <chr>          <date>                  <dbl> <chr>                      <dbl> <chr>           
    ##  1 US             2020-04-01             200141 12.90%                    213372 13.39%          
    ##  2 Italy          2020-04-01              80572 3.78%                     110574 4.52%           
    ##  3 Spain          2020-04-01              72084 5.70%                     104118 8.54%           
    ##  4 Germany        2020-04-01              58252 6.04%                      77872 8.44%           
    ##  5 France         2020-04-01              42653 7.22%                      57749 9.32%           
    ##  6 Iran           2020-04-01              29084 7.52%                      47593 6.70%           
    ##  7 UK             2020-04-01              27329 16.25%                     29865 17.20%          
    ##  8 Turkey         2020-04-01              15069 15.26%                     15679 15.87%          
    ##  9 Switzerland    2020-04-01              14313 -0.25%                     17768 7.00%           
    ## 10 Netherlands    2020-04-01              12261 7.80%                      13696 8.12%           
    ## # … with 5,686 more rows, and 4 more variables: recovered_total <dbl>, recovered_total_delta <chr>,
    ## #   deaths_total <dbl>, deaths_total_delta <chr>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

## COVID-19 daily spread

Get daily dynamics of new infected and recovered cases.

### World daily spread

    ## Selecting by active_total_per_day

    ## # A tibble: 7 x 9
    ##   observation_date confirmed_total deaths_total recovered_total active_total confirmed_total…
    ##   <date>                     <dbl>        <dbl>           <dbl>        <dbl>            <dbl>
    ## 1 2020-04-01                932605        46809          193177       692619            75118
    ## 2 2020-03-31                857487        42107          178034       637346            75122
    ## 3 2020-03-30                782365        37582          164566       580217            62248
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
    ## 1 India          2020-04-01                  1998           58             148         1792
    ## 2 India          2020-03-31                  1397           35             123         1239
    ## 3 India          2020-03-30                  1251           32             102         1117
    ## 4 India          2020-03-29                  1024           27              95          902
    ## 5 India          2020-03-28                   987           24              84          879
    ## 6 India          2020-03-27                   887           20              73          794
    ## 7 India          2020-03-26                   727           20              45          662
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

    ## # A tibble: 27 x 7
    ##    area  observation_date reference_date recovered_total deaths_total confirmed_death…
    ##    <fct> <date>           <date>                   <dbl>        <dbl>            <dbl>
    ##  1 US    2020-04-01       2020-03-06                8474         4757           0.0223
    ##  2 US    2020-03-31       2020-03-06                7024         3873           0.0206
    ##  3 US    2020-03-30       2020-03-06                5644         2978           0.0184
    ##  4 US    2020-03-29       2020-03-06                2665         2467           0.0175
    ##  5 US    2020-03-28       2020-03-06                1072         2026           0.0167
    ##  6 US    2020-03-27       2020-03-06                 869         1581           0.0156
    ##  7 US    2020-03-26       2020-03-06                 681         1209           0.0144
    ##  8 US    2020-03-25       2020-03-06                 361          942           0.0143
    ##  9 US    2020-03-24       2020-03-06                 348          706           0.0131
    ## 10 US    2020-03-23       2020-03-06                   0          552           0.0126
    ## # … with 17 more rows, and 1 more variable: recovered_deaths_rate <dbl>

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
    ##  1 Mainland China   4257799
    ##  2 US               1300824
    ##  3 Iran              575157
    ##  4 South Korea       266905
    ##  5 UK                195591
    ##  6 Others             26228
    ##  7 Russia             15051
    ##  8 Hong Kong          10391
    ##  9 Egypt               7935
    ## 10 Diamond Princess    5696
    ## 11 Taiwan              4874
    ## 12 Slovakia            3840
    ## 13 Brunei              1819
    ## 14 Venezuela           1439
    ## 15 Ivory Coast         1242

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 7 x 2
    ##   country_region       n
    ##   <chr>            <dbl>
    ## 1 Others           26228
    ## 2 Diamond Princess  5696
    ## 3 Taiwan            4874
    ## 4 Slovakia          3840
    ## 5 Brunei            1819
    ## 6 Venezuela         1439
    ## 7 Ivory Coast       1242

Much better :)

### Infected, recovered, fatal, and active cases

Calculate number of infected, recovered, fatal, and active (infected
cases minus recovered and fatal) cases grouped by country:

View statistics in US:

    ## # A tibble: 71 x 10
    ##    country_region observation_date confirmed_total recovered_total deaths_total active_total
    ##    <chr>          <date>                     <dbl>           <dbl>        <dbl>        <dbl>
    ##  1 US             2020-04-01                213372            8474         4757       200141
    ##  2 US             2020-03-31                188172            7024         3873       177275
    ##  3 US             2020-03-30                161807            5644         2978       153185
    ##  4 US             2020-03-29                140886            2665         2467       135754
    ##  5 US             2020-03-28                121478            1072         2026       118380
    ##  6 US             2020-03-27                101657             869         1581        99207
    ##  7 US             2020-03-26                 83836             681         1209        81946
    ##  8 US             2020-03-25                 65778             361          942        64475
    ##  9 US             2020-03-24                 53740             348          706        52686
    ## 10 US             2020-03-23                 43667               0          552        43115
    ## # … with 61 more rows, and 4 more variables: first_confirmed_date <date>,
    ## #   n_days_since_1st_confirmed <dbl>, first_deaths_case_date <date>, n_days_since_1st_deaths <dbl>

View statistics in Russia:

    ## # A tibble: 62 x 10
    ##    country_region observation_date confirmed_total recovered_total deaths_total active_total
    ##    <chr>          <date>                     <dbl>           <dbl>        <dbl>        <dbl>
    ##  1 Russia         2020-04-01                  2777             190           24         2563
    ##  2 Russia         2020-03-31                  2337             121           17         2199
    ##  3 Russia         2020-03-30                  1836              66            9         1761
    ##  4 Russia         2020-03-29                  1534              64            8         1462
    ##  5 Russia         2020-03-28                  1264              49            4         1211
    ##  6 Russia         2020-03-27                  1036              45            4          987
    ##  7 Russia         2020-03-26                   840              38            3          799
    ##  8 Russia         2020-03-25                   658              29            3          626
    ##  9 Russia         2020-03-24                   495              22            1          472
    ## 10 Russia         2020-03-23                   438              17            1          420
    ## # … with 52 more rows, and 4 more variables: first_confirmed_date <date>,
    ## #   n_days_since_1st_confirmed <dbl>, first_deaths_case_date <date>, n_days_since_1st_deaths <dbl>

### Join COVID-19 dataset with world population

    ## # A tibble: 62 x 5
    ##    country_region n_days_since_1st_confirmed population_n confirmed_total confirmed_total_per_1M
    ##    <chr>                               <dbl>        <dbl>           <dbl>                  <dbl>
    ##  1 Russia                                 61    144478050            2777                  19.2 
    ##  2 Russia                                 60    144478050            2337                  16.2 
    ##  3 Russia                                 59    144478050            1836                  12.7 
    ##  4 Russia                                 58    144478050            1534                  10.6 
    ##  5 Russia                                 57    144478050            1264                   8.75
    ##  6 Russia                                 56    144478050            1036                   7.17
    ##  7 Russia                                 55    144478050             840                   5.81
    ##  8 Russia                                 54    144478050             658                   4.55
    ##  9 Russia                                 53    144478050             495                   3.43
    ## 10 Russia                                 52    144478050             438                   3.03
    ## # … with 52 more rows

### TOPs countries by infected, active, and fatal cases

Calculate countries stats whose populations were most affected by the
virus:

#### Top countries by infected cases

    ## # A tibble: 47 x 5
    ##    country_region population_n confirmed_total confirmed_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>           <dbl>                  <dbl>                      <dbl>
    ##  1 Spain              46723749          104118                  2228.                         60
    ##  2 Switzerland         8516543           17768                  2086.                         36
    ##  3 Italy              60431283          110574                  1830.                         61
    ##  4 Belgium            11422068           13964                  1223.                         57
    ##  5 Austria             8847037           10711                  1211.                         36
    ##  6 Germany            82927922           77872                   939.                         64
    ##  7 Norway              5314336            4863                   915.                         35
    ##  8 France             66987244           57749                   862.                         68
    ##  9 Portugal           10281762            8251                   802.                         30
    ## 10 Netherlands        17231017           13696                   795.                         34
    ## # … with 37 more rows

#### Top countries by active cases

    ## # A tibble: 47 x 5
    ##    country_region population_n active_total active_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>        <dbl>               <dbl>                      <dbl>
    ##  1 Switzerland         8516543        14313               1681.                         36
    ##  2 Spain              46723749        72084               1543.                         60
    ##  3 Italy              60431283        80572               1333.                         61
    ##  4 Austria             8847037         9129               1032.                         36
    ##  5 Belgium            11422068        11004                963.                         57
    ##  6 Norway              5314336         4806                904.                         35
    ##  7 Portugal           10281762         8021                780.                         30
    ##  8 Netherlands        17231017        12261                712.                         34
    ##  9 Germany            82927922        58252                702.                         64
    ## 10 Ireland             4853506         3357                692.                         32
    ## # … with 37 more rows

#### Top countries by fatal cases

    ## # A tibble: 47 x 5
    ##    country_region population_n deaths_total deaths_total_per_1M n_days_since_1st_confirmed
    ##    <chr>                 <dbl>        <dbl>               <dbl>                      <dbl>
    ##  1 Italy              60431283        13155               218.                          61
    ##  2 Spain              46723749         9387               201.                          60
    ##  3 Belgium            11422068          828                72.5                         57
    ##  4 Netherlands        17231017         1175                68.2                         34
    ##  5 France             66987244         4043                60.4                         68
    ##  6 Switzerland         8516543          488                57.3                         36
    ##  7 Iran               81800269         3036                37.1                         42
    ##  8 UK                 66488991         2357                35.4                         61
    ##  9 Sweden             10183175          239                23.5                         61
    ## 10 Portugal           10281762          187                18.2                         30
    ## # … with 37 more rows

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
