COVID-19 Analytics
================
09 April, 2020

#### Table of contents

  - [Load datasets](#load-datasets)
      - [Load COVID-19 spread data](#load-covid-19-spread-data)
      - [Load world population data](#load-world-population-data)
  - [Preprocessing datasets](#preprocessing-datasets)
      - [Preprocessing COVID-19 spread
        data](#preprocessing-covid-19-spread-data)
      - [Preprocessing world population
        data](#preprocessing-world-population-data)
  - [COVID-19 worldwide spread](#covid-19-worldwide-spread)
      - [Total infected, recovered, and fatal
        cases](#total-infected,-recovered,-and-fatal-cases)
      - [Dynamics of spread](#dynamics-of-spread)
      - [Disease cases structure](#disease-cases-structure)
      - [Dynamics of daily cases](#dynamics-of-daily-cases)
  - [COVID-19 spread by countries](#covid-19-spread-by-countries)
      - [Infected, recovered, fatal, and active
        cases](#infected,-recovered,-fatal,-and-active-cases)
      - [Dynamics of spread](#dynamics-of-spread)
      - [Dynamics of daily cases](#dynamics-of-daily-cases)
      - [Mortality rate](#mortality-rate)
  - [COVID-19 spread by countries
    population](#covid-19-spread-by-countries-population)
      - [TOPs countries by infected, active, and fatal
        cases](#tops-countries-by-infected,-active,-and-fatal-cases)
          - [by infected cases](#by-infected-cases)
          - [by active cases](#by-active-cases)
          - [by fatal cases](#by-fatal-cases)
      - [Active cases per 1 million population vs number of days since
        1st infected
        case](#active-cases-per-1-million-population-vs-number-of-days-since-1st-infected-case)
      - [Active cases per 1 million population vs number of days since
        1st fatal
        case](#active-cases-per-1-million-population-vs-number-of-days-since-1st-fatal-case)

## Load datasets

### Load COVID-19 spread data

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
    ##  1   372 01/29/2020      <NA>           Finland        1/29/20 19:30              1      0         0
    ##  2  1588 02/16/2020      Shanxi         Mainland China 2020-02-16T23:53:…       129      0        50
    ##  3  1225 02/11/2020      Ningxia        Mainland China 2020-02-11T10:03:…        53      0        22
    ##  4  9099 03/26/2020      Tasmania       Australia      2020-03-26 23:53:…        47      0         3
    ##  5  2503 02/27/2020      <NA>           Japan          2020-02-27T23:33:…       214      4        22
    ##  6   768 02/05/2020      Zhejiang       Mainland China 2020-02-05T15:13:…       895      0        78
    ##  7  7250 03/20/2020      Aruba          Netherlands    2020-03-20T02:43:…         5      0         0
    ##  8  3318 03/04/2020      <NA>           Ireland        2020-03-04T21:13:…         6      0         0
    ##  9 11081 04/02/2020      <NA>           Lithuania      2020-04-02 23:32:…       649      9         7
    ## 10  1469 02/14/2020      <NA>           Russia         2020-02-12T14:43:…         2      0         2
    ## # … with 90 more rows

### Load world population data

Get datasets
    list:

    ## [1] "countries.csv"            "__MACOSX/"                "__MACOSX/._countries.csv"

Load `countries.csv` dataset:

    ## # A tibble: 169 x 14
    ##    iso_alpha2 iso_alpha3 iso_numeric name  official_name ccse_name density fertility_rate land_area
    ##    <chr>      <chr>            <int> <chr> <chr>         <chr>       <int>          <dbl>     <int>
    ##  1 AF         AFG                  4 Afgh… Islamic Repu… Afghanis…      60            4.6    652860
    ##  2 AL         ALB                  8 Alba… Republic of … Albania       105            1.6     27400
    ##  3 DZ         DZA                 12 Alge… People's Dem… Algeria        18            3.1   2381740
    ##  4 AD         AND                 20 Ando… Principality… Andorra       164           NA         470
    ##  5 AO         AGO                 24 Ango… Republic of … Angola         26            5.6   1246700
    ##  6 AG         ATG                 28 Anti… Antigua and … Antigua …     223            2         440
    ##  7 AR         ARG                 32 Arge… Argentine Re… Argentina      17            2.3   2736690
    ##  8 AM         ARM                 51 Arme… Republic of … Armenia       104            1.8     28470
    ##  9 AU         AUS                 36 Aust… Australia     Australia       3            1.8   7682300
    ## 10 AT         AUT                 40 Aust… Republic of … Austria       109            1.5     82409
    ## # … with 159 more rows, and 5 more variables: median_age <dbl>, migrants <dbl>, population <int>,
    ## #   urban_pop_rate <dbl>, world_share <dbl>

## Preprocessing datasets

### Preprocessing COVID-19 spread data

Set `area` column, processing `province_state` columns, and format dates
columns:

    ## # A tibble: 13,209 x 5
    ##    area          country        province_state observation_date confirmed
    ##    <fct>         <chr>          <chr>          <date>               <dbl>
    ##  1 US            US             New York       2020-04-08          151061
    ##  2 Rest of World Spain          <NA>           2020-04-08          148220
    ##  3 Rest of World Italy          <NA>           2020-04-08          139422
    ##  4 Rest of World Germany        <NA>           2020-04-08          113296
    ##  5 Rest of World France         <NA>           2020-04-08          112950
    ##  6 Hubei         Mainland China Hubei          2020-04-08           67803
    ##  7 Rest of World Iran           <NA>           2020-04-08           64586
    ##  8 Rest of World UK             <NA>           2020-04-08           60733
    ##  9 US            US             New Jersey     2020-04-08           47437
    ## 10 Rest of World Turkey         <NA>           2020-04-08           38226
    ## # … with 13,199 more rows

Get dataset structure after preprocessing:

|                                                  |            |
| :----------------------------------------------- | :--------- |
| Name                                             | Piped data |
| Number of rows                                   | 13209      |
| Number of columns                                | 9          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |            |
| Column type frequency:                           |            |
| character                                        | 2          |
| Date                                             | 1          |
| factor                                           | 1          |
| numeric                                          | 4          |
| POSIXct                                          | 1          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |            |
| Group variables                                  | None       |

Data summary

**Variable type:
character**

| skim\_variable  | n\_missing | complete\_rate | min | max | empty | n\_unique | whitespace |
| :-------------- | ---------: | -------------: | --: | --: | ----: | --------: | ---------: |
| province\_state |       6385 |           0.52 |   2 |  43 |     0 |       295 |          0 |
| country         |          0 |           1.00 |   2 |  32 |     0 |       219 |          1 |

**Variable type:
Date**

| skim\_variable    | n\_missing | complete\_rate | min        | max        | median     | n\_unique |
| :---------------- | ---------: | -------------: | :--------- | :--------- | :--------- | --------: |
| observation\_date |          0 |              1 | 2020-01-22 | 2020-04-08 | 2020-03-18 |        78 |

**Variable type:
factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts                             |
| :------------- | ---------: | -------------: | :------ | --------: | :-------------------------------------- |
| area           |          0 |              1 | FALSE   |         4 | Res: 8179, US: 2614, Chi: 2338, Hub: 78 |

**Variable type:
numeric**

| skim\_variable | n\_missing | complete\_rate |    mean |      sd | p0 |  p25 |  p50 |  p75 |   p100 | hist  |
| :------------- | ---------: | -------------: | ------: | ------: | -: | ---: | ---: | ---: | -----: | :---- |
| sno            |          0 |              1 | 6605.00 | 3813.25 |  1 | 3303 | 6605 | 9907 |  13209 | ▇▇▇▇▇ |
| confirmed      |          0 |              1 | 1544.31 | 8848.86 |  0 |    5 |   51 |  345 | 151061 | ▇▁▁▁▁ |
| deaths         |          0 |              1 |   73.53 |  669.86 |  0 |    0 |    0 |    3 |  17669 | ▇▁▁▁▁ |
| recovered      |          0 |              1 |  388.37 | 3469.00 |  0 |    0 |    1 |   24 |  64142 | ▇▁▁▁▁ |

**Variable type:
POSIXct**

| skim\_variable | n\_missing | complete\_rate | min                 | max                 | median              | n\_unique |
| :------------- | ---------: | -------------: | :------------------ | :------------------ | :------------------ | --------: |
| last\_update   |          0 |              1 | 2020-01-22 17:00:00 | 2020-04-08 22:59:00 | 2020-03-14 16:13:55 |      1819 |

### Preprocessing world population data

Get unmatched countries:

    ## # A tibble: 56 x 2
    ##    country                  n
    ##    <chr>                <dbl>
    ##  1 Mainland China     4829567
    ##  2 UK                  529068
    ##  3 South Korea         338335
    ##  4 Czech Republic       61651
    ##  5 Others               26228
    ##  6 Hong Kong            16599
    ##  7 Diamond Princess     10680
    ##  8 Taiwan                7407
    ##  9 Ivory Coast           3216
    ## 10 West Bank and Gaza    2338
    ## # … with 46 more rows

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 51 x 2
    ##    country                n
    ##    <chr>              <dbl>
    ##  1 Others             26228
    ##  2 Hong Kong          16599
    ##  3 Diamond Princess   10680
    ##  4 Ivory Coast         3216
    ##  5 West Bank and Gaza  2338
    ##  6 Kosovo              1717
    ##  7 Macau               1230
    ##  8 Mali                 460
    ##  9 Burma                218
    ## 10 Guadeloupe           187
    ## # … with 41 more rows

Much better :)

## COVID-19 worldwide spread

***Analyze COVID-19 worldwide spread.***

### Total infected, recovered, and fatal cases

View spread statistics:

    ## # A tibble: 78 x 9
    ##    observation_date active_total active_total_de… confirmed_total confirmed_total… recovered_total
    ##    <date>                  <dbl> <chr>                      <dbl> <chr>                      <dbl>
    ##  1 2020-04-08            1094105 4.78%                    1511104 5.96%                     328661
    ##  2 2020-04-07            1044177 5.05%                    1426096 6.02%                     300054
    ##  3 2020-04-06             994021 5.44%                    1345101 5.74%                     276515
    ##  4 2020-04-05             942729 6.33%                    1272115 6.24%                     260012
    ##  5 2020-04-04             886647 9.28%                    1197405 9.26%                     246152
    ##  6 2020-04-03             811334 8.19%                    1095917 8.17%                     225796
    ##  7 2020-04-02             749911 8.27%                    1013157 8.64%                     210263
    ##  8 2020-04-01             692619 8.67%                     932605 8.76%                     193177
    ##  9 2020-03-31             637346 9.84%                     857487 9.60%                     178034
    ## 10 2020-03-30             580247 8.03%                     782395 8.64%                     164566
    ## # … with 68 more rows, and 3 more variables: recovered_total_delta <chr>, deaths_total <dbl>,
    ## #   deaths_total_delta <chr>

### Dynamics of spread

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/worldwide_spread_over_time-1.png)<!-- -->

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

### Disease cases structure

![](covid-19-eda_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

### Dynamics of daily cases

Get daily dynamics of new infected and recovered cases.

World daily spread:

    ## Selecting by active_total_per_day

    ## # A tibble: 7 x 5
    ##   observation_date confirmed_total_per_… deaths_total_per_d… recovered_total_per… active_total_per_…
    ##   <date>                           <dbl>               <dbl>                <dbl>              <dbl>
    ## 1 2020-04-05                       74710                4768                13860              56082
    ## 2 2020-04-04                      101488                5819                20356              75313
    ## 3 2020-04-03                       82760                5804                15533              61423
    ## 4 2020-04-02                       80552                6174                17086              57292
    ## 5 2020-04-01                       75118                4702                15143              55273
    ## 6 2020-03-31                       75092                4525                13468              57099
    ## 7 2020-03-28                       67415                3454                 8500              55461

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

## COVID-19 spread by countries

***Analyze COVID-19 spread y countries.***

### Infected, recovered, fatal, and active cases

Calculate number of infected, recovered, fatal, and active (infected
cases minus recovered and fatal) cases grouped by country:

Get countries ordered by total active cases:

    ## # A tibble: 6,980 x 10
    ##    country observation_date active_total active_total_de… confirmed_total confirmed_total…
    ##    <chr>   <date>                  <dbl> <chr>                      <dbl> <chr>           
    ##  1 US      2020-04-08             390798 8.03%                     429052 8.29%           
    ##  2 Italy   2020-04-08              95262 1.27%                     139422 2.83%           
    ##  3 Spain   2020-04-08              85407 0.85%                     148220 4.42%           
    ##  4 France  2020-04-08              81620 1.77%                     113959 3.54%           
    ##  5 Germany 2020-04-08              64647 -7.07%                    113296 5.23%           
    ##  6 United… 2020-04-08              54018 9.23%                      61474 9.88%           
    ##  7 Turkey  2020-04-08              35568 11.84%                     38226 12.07%          
    ##  8 Iran    2020-04-08              30781 -2.83%                     64586 3.19%           
    ##  9 Nether… 2020-04-08              18155 4.77%                      20682 4.94%           
    ## 10 Belgium 2020-04-08              16482 3.00%                      23403 5.45%           
    ## # … with 6,970 more rows, and 4 more variables: recovered_total <dbl>, recovered_total_delta <chr>,
    ## #   deaths_total <dbl>, deaths_total_delta <chr>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

### Dynamics of spread

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

### Dynamics of daily cases

Get daily dynamics of new infected and recovered cases by countries.

World daily spread:

    ## # A tibble: 6,980 x 6
    ## # Groups:   country [219]
    ##    country   observation_date confirmed_total_p… recovered_total_… deaths_total_pe… active_total_pe…
    ##    <chr>     <date>                        <dbl>             <dbl>            <dbl>            <dbl>
    ##  1 Afghanis… 2020-04-08                       21                11                0               10
    ##  2 Albania   2020-04-08                       17                23                0               -6
    ##  3 Algeria   2020-04-08                      104               124               12              -32
    ##  4 Andorra   2020-04-08                       19                13                1                5
    ##  5 Angola    2020-04-08                        2                 0                0                2
    ##  6 Antigua … 2020-04-08                        0                 0                1               -1
    ##  7 Argentina 2020-04-08                       87                20                7               60
    ##  8 Armenia   2020-04-08                       28                27                1                0
    ##  9 Australia 2020-04-08                      115                 0                5              110
    ## 10 Austria   2020-04-08                      303               466               30             -193
    ## # … with 6,970 more rows

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

### Mortality rate

    ## # A tibble: 40 x 8
    ##    country observation_date first_confirmed… first_deaths_ca… recovered_total deaths_total
    ##    <chr>   <date>           <date>           <date>                     <dbl>        <dbl>
    ##  1 US      2020-04-08       2020-01-22       2020-02-29                 23559        14695
    ##  2 US      2020-04-07       2020-01-22       2020-02-29                 21763        12722
    ##  3 US      2020-04-06       2020-01-22       2020-02-29                 19581        10783
    ##  4 US      2020-04-05       2020-01-22       2020-02-29                 17448         9619
    ##  5 US      2020-04-04       2020-01-22       2020-02-29                 14652         8407
    ##  6 US      2020-04-03       2020-01-22       2020-02-29                  9707         7087
    ##  7 US      2020-04-02       2020-01-22       2020-02-29                  9001         5926
    ##  8 US      2020-04-01       2020-01-22       2020-02-29                  8474         4757
    ##  9 US      2020-03-31       2020-01-22       2020-02-29                  7024         3873
    ## 10 US      2020-03-30       2020-01-22       2020-02-29                  5644         2978
    ## # … with 30 more rows, and 2 more variables: confirmed_deaths_rate <dbl>,
    ## #   recovered_deaths_rate <dbl>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

## COVID-19 spread by countries population

    ## # A tibble: 69 x 5
    ##    country n_days_since_1st_confirmed population confirmed_total confirmed_total_per_1M
    ##    <chr>                        <dbl>      <int>           <dbl>                  <dbl>
    ##  1 Russia                          68  145934462            8672                   59.4
    ##  2 Russia                          67  145934462            7497                   51.4
    ##  3 Russia                          66  145934462            6343                   43.5
    ##  4 Russia                          65  145934462            5389                   36.9
    ##  5 Russia                          64  145934462            4731                   32.4
    ##  6 Russia                          63  145934462            4149                   28.4
    ##  7 Russia                          62  145934462            3548                   24.3
    ##  8 Russia                          61  145934462            2777                   19.0
    ##  9 Russia                          60  145934462            2337                   16.0
    ## 10 Russia                          59  145934462            1836                   12.6
    ## # … with 59 more rows

### TOPs countries by infected, active, and fatal cases

Calculate countries stats whose populations were most affected by the
virus:

#### …by infected cases

    ## # A tibble: 61 x 6
    ##    country   population confirmed_total confirmed_total_pe… n_days_since_1st_co… n_days_since_1st_d…
    ##    <chr>          <int>           <dbl>               <dbl>                <dbl>               <dbl>
    ##  1 Spain       46754778          148220               3170.                   67                  36
    ##  2 Switzerl…    8654622           23280               2690.                   43                  34
    ##  3 Italy       60461826          139422               2306.                   68                  47
    ##  4 Belgium     11589623           23403               2019.                   64                  28
    ##  5 France      65273511          113959               1746.                   75                  53
    ##  6 Austria      9006398           12942               1437.                   43                  27
    ##  7 Germany     83783942          113296               1352.                   71                  30
    ##  8 US         331002651          429052               1296.                   77                  39
    ##  9 Portugal    10196709           13141               1289.                   37                  22
    ## 10 Ireland      4937786            6074               1230.                   39                  28
    ## # … with 51 more rows

#### …by active cases

    ## # A tibble: 61 x 6
    ##    country    population active_total active_total_per_… n_days_since_1st_conf… n_days_since_1st_de…
    ##    <chr>           <int>        <dbl>              <dbl>                  <dbl>                <dbl>
    ##  1 Spain        46754778        85407              1827.                     67                   36
    ##  2 Italy        60461826        95262              1576.                     68                   47
    ##  3 Switzerla…    8654622        12585              1454.                     43                   34
    ##  4 Belgium      11589623        16482              1422.                     64                   28
    ##  5 France       65273511        81620              1250.                     75                   53
    ##  6 Portugal     10196709        12565              1232.                     37                   22
    ##  7 US          331002651       390798              1181.                     77                   39
    ##  8 Ireland       4937786         5814              1177.                     39                   28
    ##  9 Norway        5421241         5953              1098.                     42                   25
    ## 10 Netherlan…   17134872        18155              1060.                     41                   33
    ## # … with 51 more rows

#### …by fatal cases

    ## # A tibble: 61 x 6
    ##    country     population deaths_total deaths_total_per_… n_days_since_1st_conf… n_days_since_1st_d…
    ##    <chr>            <int>        <dbl>              <dbl>                  <dbl>               <dbl>
    ##  1 Spain         46754778        14792              316.                      67                  36
    ##  2 Italy         60461826        17669              292.                      68                  47
    ##  3 Belgium       11589623         2240              193.                      64                  28
    ##  4 France        65273511        10887              167.                      75                  53
    ##  5 Netherlands   17134872         2255              132.                      41                  33
    ##  6 United Kin…   67886011         7111              105.                      68                  34
    ##  7 Switzerland    8654622          895              103.                      43                  34
    ##  8 Sweden        10099265          687               68.0                     68                  28
    ##  9 Ireland        4937786          235               47.6                     39                  28
    ## 10 Iran          83992949         3993               47.5                     49                  49
    ## # … with 51 more rows

### Active cases per 1 million population vs number of days since 1st infected case

Select countries to
    monitoring:

    ##  [1] "Belgium"        "France"         "Ireland"        "Italy"          "Netherlands"   
    ##  [6] "Norway"         "Portugal"       "Spain"          "Switzerland"    "US"            
    ## [11] "Russia"         "India"          "Mainland China" "South Korea"

![](covid-19-eda_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

### Active cases per 1 million population vs number of days since 1st fatal case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->
