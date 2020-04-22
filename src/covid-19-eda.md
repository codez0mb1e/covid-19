COVID-19 Analytics
================
22 April, 2020

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
        100th infected
        case](#active-cases-per-1-million-population-vs-number-of-days-since-100th-infected-case)
      - [Active cases per 1 million population vs number of days since
        10th fatal
        case](#active-cases-per-1-million-population-vs-number-of-days-since-10th-fatal-case)

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
    ##      SNo ObservationDate Province.State      Country.Region Last.Update   Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>               <chr>          <chr>             <dbl>  <dbl>     <dbl>
    ##  1  5081 03/12/2020      <NA>                Tunisia        2020-03-11T1…         7      0         0
    ##  2 16240 04/18/2020      <NA>                South Africa   2020-04-18 2…      3034     52       903
    ##  3 14730 04/13/2020      Kentucky            US             2020-04-13 2…      2018    113         0
    ##  4  1018 02/08/2020      <NA>                Germany        2020-02-07T1…        13      0         0
    ##  5  7800 03/22/2020      Diamond Princess c… Canada         3/8/20 5:31           0      1         0
    ##  6  9862 03/29/2020      <NA>                Portugal       3/8/20 5:31        5962    119        43
    ##  7  9116 03/27/2020      <NA>                Afghanistan    2020-03-27 2…       110      4         2
    ##  8 13794 04/10/2020      Newfoundland and L… Canada         2020-04-10 2…       239      3         0
    ##  9  5413 03/14/2020      Heilongjiang        Mainland China 2020-03-14T0…       482     13       447
    ## 10  1672 02/17/2020      <NA>                Japan          2020-02-17T1…        66      1        12
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

    ## # A tibble: 17,049 x 5
    ##    area          country        province_state observation_date confirmed
    ##    <fct>         <chr>          <chr>          <date>               <dbl>
    ##  1 US            US             New York       2020-04-20          253060
    ##  2 Rest of World Spain          <NA>           2020-04-20          200210
    ##  3 Rest of World Italy          <NA>           2020-04-20          181228
    ##  4 Rest of World France         <NA>           2020-04-20          155275
    ##  5 Rest of World Germany        <NA>           2020-04-20          147065
    ##  6 Rest of World UK             <NA>           2020-04-20          124743
    ##  7 Rest of World Turkey         <NA>           2020-04-20           90980
    ##  8 US            US             New Jersey     2020-04-20           88722
    ##  9 Rest of World Iran           <NA>           2020-04-20           83505
    ## 10 Hubei         Mainland China Hubei          2020-04-20           68128
    ## # … with 17,039 more rows

Get dataset structure after preprocessing:

|                                                  |            |
| :----------------------------------------------- | :--------- |
| Name                                             | Piped data |
| Number of rows                                   | 17049      |
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
| province\_state |       8556 |            0.5 |   2 |  43 |     0 |       295 |          0 |
| country         |          0 |            1.0 |   2 |  32 |     0 |       220 |          1 |

**Variable type:
Date**

| skim\_variable    | n\_missing | complete\_rate | min        | max        | median     | n\_unique |
| :---------------- | ---------: | -------------: | :--------- | :--------- | :--------- | --------: |
| observation\_date |          0 |              1 | 2020-01-22 | 2020-04-20 | 2020-03-25 |        90 |

**Variable type:
factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts                              |
| :------------- | ---------: | -------------: | :------ | --------: | :--------------------------------------- |
| area           |          0 |              1 | FALSE   |         4 | Res: 10953, US: 3308, Chi: 2698, Hub: 90 |

**Variable type:
numeric**

| skim\_variable | n\_missing | complete\_rate |    mean |       sd | p0 |  p25 |  p50 |   p75 |   p100 | hist  |
| :------------- | ---------: | -------------: | ------: | -------: | -: | ---: | ---: | ----: | -----: | :---- |
| sno            |          0 |              1 | 8525.00 |  4921.77 |  1 | 4263 | 8525 | 12787 |  17049 | ▇▇▇▇▇ |
| confirmed      |          0 |              1 | 2629.95 | 13579.29 |  0 |    8 |   89 |   588 | 253060 | ▇▁▁▁▁ |
| deaths         |          0 |              1 |  150.37 |  1185.57 |  0 |    0 |    1 |     7 |  24114 | ▇▁▁▁▁ |
| recovered      |          0 |              1 |  650.49 |  4967.68 |  0 |    0 |    1 |    55 |  91500 | ▇▁▁▁▁ |

**Variable type:
POSIXct**

| skim\_variable | n\_missing | complete\_rate | min                 | max                 | median              | n\_unique |
| :------------- | ---------: | -------------: | :------------------ | :------------------ | :------------------ | --------: |
| last\_update   |          0 |              1 | 2020-01-22 17:00:00 | 2020-04-20 23:44:50 | 2020-03-20 16:13:23 |      1830 |

### Preprocessing world population data

Get unmatched countries:

    ## # A tibble: 57 x 2
    ##    country                  n
    ##    <chr>                <dbl>
    ##  1 Mainland China     5817330
    ##  2 UK                 1694779
    ##  3 South Korea         465128
    ##  4 Czech Republic      136394
    ##  5 Hong Kong            28715
    ##  6 Others               26228
    ##  7 Diamond Princess     19224
    ##  8 Taiwan               12153
    ##  9 Ivory Coast          10950
    ## 10 West Bank and Gaza    6496
    ## # … with 47 more rows

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 52 x 2
    ##    country                n
    ##    <chr>              <dbl>
    ##  1 Hong Kong          28715
    ##  2 Others             26228
    ##  3 Diamond Princess   19224
    ##  4 Ivory Coast        10950
    ##  5 West Bank and Gaza  6496
    ##  6 Kosovo              6233
    ##  7 Mali                2256
    ##  8 Macau               1770
    ##  9 Burma               1047
    ## 10 Guinea-Bissau        678
    ## # … with 42 more rows

Much better :)

## COVID-19 worldwide spread

***Analyze COVID-19 worldwide spread.***

### Total infected, recovered, and fatal cases

View spread statistics:

    ## # A tibble: 90 x 9
    ##    observation_date active_total active_total_de… confirmed_total confirmed_total… recovered_total
    ##    <date>                  <dbl> <chr>                      <dbl> <chr>                      <dbl>
    ##  1 2020-04-20            1656535 2.74%                    2472259 2.95%                     645738
    ##  2 2020-04-19            1612432 2.97%                    2401379 3.61%                     623903
    ##  3 2020-04-18            1565930 3.16%                    2317759 3.46%                     592319
    ##  4 2020-04-17            1518026 3.50%                    2240191 4.07%                     568343
    ##  5 2020-04-16            1466739 3.96%                    2152647 4.70%                     542107
    ##  6 2020-04-15            1410859 2.54%                    2056055 4.04%                     511019
    ##  7 2020-04-14            1375947 1.98%                    1976192 3.07%                     474261
    ##  8 2020-04-13            1349183 2.92%                    1917320 3.83%                     448655
    ##  9 2020-04-12            1310869 3.96%                    1846680 4.24%                     421722
    ## 10 2020-04-11            1260902 3.94%                    1771514 4.72%                     402110
    ## # … with 80 more rows, and 3 more variables: recovered_total_delta <chr>, deaths_total <dbl>,
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
    ## 1 2020-04-16                       96592                9624                31088              55880
    ## 2 2020-04-10                       96369                7070                22121              67178
    ## 3 2020-04-05                       74707                4768                13860              56079
    ## 4 2020-04-04                      101491                5819                20356              75316
    ## 5 2020-04-03                       82614                5804                15533              61277
    ## 6 2020-04-02                       80698                6174                17092              57432
    ## 7 2020-03-31                       75098                4525                13468              57105

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

    ## # A tibble: 4,165 x 10
    ##    country observation_date active_total active_total_de… confirmed_total confirmed_total…
    ##    <chr>   <date>                  <dbl> <chr>                      <dbl> <chr>           
    ##  1 US      2020-04-20             669903 3.37%                     784326 3.33%           
    ##  2 United… 2020-04-20             108860 4.03%                     125856 3.87%           
    ##  3 Italy   2020-04-20             108237 -0.02%                    181228 1.26%           
    ##  4 Spain   2020-04-20              98771 -2.08%                    200210 0.77%           
    ##  5 France  2020-04-20              98152 1.01%                     156480 1.55%           
    ##  6 Turkey  2020-04-20              75410 4.28%                      90980 5.42%           
    ##  7 Germany 2020-04-20              50703 -3.60%                    147065 1.30%           
    ##  8 Russia  2020-04-20              43270 10.38%                     47121 9.96%           
    ##  9 Nether… 2020-04-20              29502 2.37%                      33588 2.28%           
    ## 10 Belgium 2020-04-20              25260 5.00%                      39983 3.86%           
    ## # … with 4,155 more rows, and 4 more variables: recovered_total <dbl>, recovered_total_delta <chr>,
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

    ## # A tibble: 4,165 x 6
    ## # Groups:   country [133]
    ##    country  observation_date confirmed_total_p… recovered_total_p… deaths_total_pe… active_total_pe…
    ##    <chr>    <date>                        <dbl>              <dbl>            <dbl>            <dbl>
    ##  1 Afghani… 2020-04-20                       30                  4                3               23
    ##  2 Albania  2020-04-20                       22                 13                0                9
    ##  3 Algeria  2020-04-20                       89                 52                9               28
    ##  4 Andorra  2020-04-20                        4                 13                1              -10
    ##  5 Argenti… 2020-04-20                      102                 28                4               70
    ##  6 Armenia  2020-04-20                       48                 35                2               11
    ##  7 Austral… 2020-04-20                        0                  0                0                0
    ##  8 Austria  2020-04-20                       46                130               18             -102
    ##  9 Azerbai… 2020-04-20                       38                 79                0              -41
    ## 10 Bahrain  2020-04-20                       26                 10                0               16
    ## # … with 4,155 more rows

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

### Mortality rate

    ## # A tibble: 42 x 8
    ##    country observation_date since_100_confi… since_10_deaths… recovered_total deaths_total
    ##    <chr>   <date>           <date>           <date>                     <dbl>        <dbl>
    ##  1 US      2020-04-20       2020-03-10       2020-03-04                 72329        42094
    ##  2 US      2020-04-19       2020-03-10       2020-03-04                 70337        40661
    ##  3 US      2020-04-18       2020-03-10       2020-03-04                 64840        38664
    ##  4 US      2020-04-17       2020-03-10       2020-03-04                 58545        36773
    ##  5 US      2020-04-16       2020-03-10       2020-03-04                 54703        32916
    ##  6 US      2020-04-15       2020-03-10       2020-03-04                 52096        28325
    ##  7 US      2020-04-14       2020-03-10       2020-03-04                 47763        25831
    ##  8 US      2020-04-13       2020-03-10       2020-03-04                 43482        23528
    ##  9 US      2020-04-12       2020-03-10       2020-03-04                 32988        22019
    ## 10 US      2020-04-11       2020-03-10       2020-03-04                 31270        20462
    ## # … with 32 more rows, and 2 more variables: confirmed_deaths_rate <dbl>,
    ## #   recovered_deaths_rate <dbl>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

## COVID-19 spread by countries population

    ## # A tibble: 35 x 5
    ##    country n_days_since_100_confirmed population confirmed_total confirmed_total_per_1M
    ##    <chr>                        <dbl>      <int>           <dbl>                  <dbl>
    ##  1 Russia                          34  145934462           47121                  323. 
    ##  2 Russia                          33  145934462           42853                  294. 
    ##  3 Russia                          32  145934462           36793                  252. 
    ##  4 Russia                          31  145934462           32008                  219. 
    ##  5 Russia                          30  145934462           27938                  191. 
    ##  6 Russia                          29  145934462           24490                  168. 
    ##  7 Russia                          28  145934462           21102                  145. 
    ##  8 Russia                          27  145934462           18328                  126. 
    ##  9 Russia                          26  145934462           15770                  108. 
    ## 10 Russia                          25  145934462           13584                   93.1
    ## # … with 25 more rows

### TOPs countries by infected, active, and fatal cases

Calculate countries stats whose populations were most affected by the
virus:

#### …by infected cases

    ## # A tibble: 78 x 6
    ##    country   population confirmed_total confirmed_total_pe… n_days_since_100_co… n_days_since_10th_…
    ##    <chr>          <int>           <dbl>               <dbl>                <dbl>               <dbl>
    ##  1 Spain       46754778          200210               4282.                   49                  43
    ##  2 Belgium     11589623           39983               3450.                   45                  33
    ##  3 Switzerl…    8654622           27944               3229.                   46                  38
    ##  4 Ireland      4937786           15652               3170.                   37                  25
    ##  5 Italy       60461826          181228               2997.                   57                  54
    ##  6 France      65273511          156480               2397.                   50                  44
    ##  7 US         331002651          784326               2370.                   41                  47
    ##  8 Qatar        2881053            6015               2088.                   40                  NA
    ##  9 Portugal    10196709           20863               2046.                   38                  30
    ## 10 Netherla…   17134872           33588               1960.                   45                  37
    ## # … with 68 more rows

#### …by active cases

    ## # A tibble: 78 x 6
    ##    country     population active_total active_total_per_… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>            <int>        <dbl>              <dbl>                 <dbl>                <dbl>
    ##  1 Ireland        4937786        14888              3015.                    37                   25
    ##  2 Belgium       11589623        25260              2180.                    45                   33
    ##  3 Spain         46754778        98771              2113.                    49                   43
    ##  4 US           331002651       669903              2024.                    41                   47
    ##  5 Portugal      10196709        19518              1914.                    38                   30
    ##  6 Qatar          2881053         5451              1892.                    40                   NA
    ##  7 Italy         60461826       108237              1790.                    57                   54
    ##  8 Netherlands   17134872        29502              1722.                    45                   37
    ##  9 United Kin…   67886011       108860              1604.                    46                   37
    ## 10 France        65273511        98152              1504.                    50                   44
    ## # … with 68 more rows

#### …by fatal cases

    ## # A tibble: 78 x 6
    ##    country     population deaths_total deaths_total_per_… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>            <int>        <dbl>              <dbl>                 <dbl>                <dbl>
    ##  1 Belgium       11589623         5828               503.                    45                   33
    ##  2 Spain         46754778        20852               446.                    49                   43
    ##  3 Italy         60461826        24114               399.                    57                   54
    ##  4 France        65273511        20292               311.                    50                   44
    ##  5 United Kin…   67886011        16550               244.                    46                   37
    ##  6 Netherlands   17134872         3764               220.                    45                   37
    ##  7 Switzerland    8654622         1429               165.                    46                   38
    ##  8 Sweden        10099265         1580               156.                    45                   32
    ##  9 Ireland        4937786          687               139.                    37                   25
    ## 10 US           331002651        42094               127.                    41                   47
    ## # … with 68 more rows

### Active cases per 1 million population vs number of days since 100th infected case

Select countries to
    monitoring:

    ##  [1] "Belgium"        "France"         "Ireland"        "Italy"          "Netherlands"   
    ##  [6] "Portugal"       "Qatar"          "Spain"          "United Kingdom" "US"            
    ## [11] "Russia"         "Mainland China" "Korea, South"

![](covid-19-eda_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

### Active cases per 1 million population vs number of days since 10th fatal case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->

***Stay healthy. Help the sick.***
