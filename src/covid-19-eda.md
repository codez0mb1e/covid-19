COVID-19 Analytics
================
10 April, 2020

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
    ##  1 10326 03/30/2020      Rhode Island   US             3/8/20 5:31              408      4         0
    ##  2  5469 03/14/2020      Illinois       US             2020-03-14T22:33:…        64      0         2
    ##  3   910 02/07/2020      Zhejiang       Mainland China 2020-02-07T11:33:…      1006      0       123
    ##  4  7259 03/20/2020      <NA>           Gabon          2020-03-20T15:13:…         3      1         0
    ##  5   788 02/05/2020      Tianjin        Mainland China 2020-02-05T03:43:…        69      1         2
    ##  6  9167 03/27/2020      <NA>           Eritrea        2020-03-27 23:27:…         6      0         0
    ##  7  1353 02/13/2020      Heilongjiang   Mainland China 2020-02-13T12:13:…       395      9        33
    ##  8 11201 04/02/2020      Guangxi        Mainland China 4/2/20 8:53              254      2       252
    ##  9  2147 02/23/2020      <NA>           Thailand       2020-02-23T15:03:…        35      0        21
    ## 10  9084 03/26/2020      Recovered      US             2020-03-26 23:53:…         0      0       681
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

    ## # A tibble: 13,529 x 5
    ##    area          country        province_state observation_date confirmed
    ##    <fct>         <chr>          <chr>          <date>               <dbl>
    ##  1 US            US             New York       2020-04-09          161779
    ##  2 Rest of World Spain          <NA>           2020-04-09          153222
    ##  3 Rest of World Italy          <NA>           2020-04-09          143626
    ##  4 Rest of World Germany        <NA>           2020-04-09          118181
    ##  5 Rest of World France         <NA>           2020-04-09          117749
    ##  6 Hubei         Mainland China Hubei          2020-04-09           67803
    ##  7 Rest of World Iran           <NA>           2020-04-09           66220
    ##  8 Rest of World UK             <NA>           2020-04-09           65077
    ##  9 US            US             New Jersey     2020-04-09           51027
    ## 10 Rest of World Turkey         <NA>           2020-04-09           42282
    ## # … with 13,519 more rows

Get dataset structure after preprocessing:

|                                                  |            |
| :----------------------------------------------- | :--------- |
| Name                                             | Piped data |
| Number of rows                                   | 13529      |
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
| province\_state |       6565 |           0.51 |   2 |  43 |     0 |       295 |          0 |
| country         |          0 |           1.00 |   2 |  32 |     0 |       219 |          1 |

**Variable type:
Date**

| skim\_variable    | n\_missing | complete\_rate | min        | max        | median     | n\_unique |
| :---------------- | ---------: | -------------: | :--------- | :--------- | :--------- | --------: |
| observation\_date |          0 |              1 | 2020-01-22 | 2020-04-09 | 2020-03-19 |        79 |

**Variable type:
factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts                             |
| :------------- | ---------: | -------------: | :------ | --------: | :-------------------------------------- |
| area           |          0 |              1 | FALSE   |         4 | Res: 8410, US: 2672, Chi: 2368, Hub: 79 |

**Variable type:
numeric**

| skim\_variable | n\_missing | complete\_rate |    mean |      sd | p0 |  p25 |  p50 |   p75 |   p100 | hist  |
| :------------- | ---------: | -------------: | ------: | ------: | -: | ---: | ---: | ----: | -----: | :---- |
| sno            |          0 |              1 | 6765.00 | 3905.63 |  1 | 3383 | 6765 | 10147 |  13529 | ▇▇▇▇▇ |
| confirmed      |          0 |              1 | 1625.71 | 9229.11 |  0 |    5 |   55 |   367 | 161779 | ▇▁▁▁▁ |
| deaths         |          0 |              1 |   78.85 |  709.31 |  0 |    0 |    0 |     4 |  18279 | ▇▁▁▁▁ |
| recovered      |          0 |              1 |  405.35 | 3561.74 |  0 |    0 |    1 |    26 |  64187 | ▇▁▁▁▁ |

**Variable type:
POSIXct**

| skim\_variable | n\_missing | complete\_rate | min                 | max                 | median              | n\_unique |
| :------------- | ---------: | -------------: | :------------------ | :------------------ | :------------------ | --------: |
| last\_update   |          0 |              1 | 2020-01-22 17:00:00 | 2020-04-09 23:09:19 | 2020-03-13 22:22:02 |      1819 |

### Preprocessing world population data

Get unmatched countries:

    ## # A tibble: 56 x 2
    ##    country                  n
    ##    <chr>                <dbl>
    ##  1 Mainland China     4911432
    ##  2 UK                  594940
    ##  3 South Korea         348758
    ##  4 Czech Republic       67220
    ##  5 Others               26228
    ##  6 Hong Kong            17572
    ##  7 Diamond Princess     11392
    ##  8 Taiwan                7787
    ##  9 Ivory Coast           3660
    ## 10 West Bank and Gaza    2601
    ## # … with 46 more rows

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 51 x 2
    ##    country                n
    ##    <chr>              <dbl>
    ##  1 Others             26228
    ##  2 Hong Kong          17572
    ##  3 Diamond Princess   11392
    ##  4 Ivory Coast         3660
    ##  5 West Bank and Gaza  2601
    ##  6 Kosovo              1901
    ##  7 Macau               1275
    ##  8 Mali                 534
    ##  9 Burma                241
    ## 10 Guinea-Bissau        215
    ## # … with 41 more rows

Much better :)

## COVID-19 worldwide spread

***Analyze COVID-19 worldwide spread.***

### Total infected, recovered, and fatal cases

View spread statistics:

    ## # A tibble: 79 x 9
    ##    observation_date active_total active_total_de… confirmed_total confirmed_total… recovered_total
    ##    <date>                  <dbl> <chr>                      <dbl> <chr>                      <dbl>
    ##  1 2020-04-09            1145920 4.74%                    1595350 5.58%                     353975
    ##  2 2020-04-08            1094105 4.78%                    1511104 5.96%                     328661
    ##  3 2020-04-07            1044177 5.05%                    1426096 6.02%                     300054
    ##  4 2020-04-06             994021 5.44%                    1345101 5.74%                     276515
    ##  5 2020-04-05             942729 6.32%                    1272115 6.24%                     260012
    ##  6 2020-04-04             886650 9.28%                    1197408 9.26%                     246152
    ##  7 2020-04-03             811334 8.17%                    1095917 8.15%                     225796
    ##  8 2020-04-02             750057 8.29%                    1013303 8.65%                     210263
    ##  9 2020-04-01             692619 8.67%                     932605 8.76%                     193177
    ## 10 2020-03-31             637346 9.84%                     857487 9.60%                     178034
    ## # … with 69 more rows, and 3 more variables: recovered_total_delta <chr>, deaths_total <dbl>,
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
    ## 1 2020-04-05                       74707                4768                13860              56079
    ## 2 2020-04-04                      101491                5819                20356              75316
    ## 3 2020-04-03                       82614                5804                15533              61277
    ## 4 2020-04-02                       80698                6174                17086              57438
    ## 5 2020-04-01                       75118                4702                15143              55273
    ## 6 2020-03-31                       75098                4525                13468              57105
    ## 7 2020-03-28                       67402                3454                 8500              55448

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

    ## # A tibble: 7,166 x 10
    ##    country observation_date active_total active_total_de… confirmed_total confirmed_total…
    ##    <chr>   <date>                  <dbl> <chr>                      <dbl> <chr>           
    ##  1 US      2020-04-09             419549 7.36%                     461437 7.55%           
    ##  2 Italy   2020-04-09              96877 1.70%                     143626 3.02%           
    ##  3 Spain   2020-04-09              85610 0.24%                     153222 3.37%           
    ##  4 France  2020-04-09              83140 1.86%                     118781 4.23%           
    ##  5 Germany 2020-04-09              63167 -2.29%                    118181 4.31%           
    ##  6 United… 2020-04-09              57520 6.48%                      65872 7.15%           
    ##  7 Turkey  2020-04-09              39232 10.30%                     42282 10.61%          
    ##  8 Iran    2020-04-09              29801 -3.18%                     66220 2.53%           
    ##  9 Nether… 2020-04-09              19222 5.88%                      21903 5.90%           
    ## 10 Belgium 2020-04-09              17296 4.94%                      24983 6.75%           
    ## # … with 7,156 more rows, and 4 more variables: recovered_total <dbl>, recovered_total_delta <chr>,
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

    ## # A tibble: 7,166 x 6
    ## # Groups:   country [219]
    ##    country   observation_date confirmed_total_p… recovered_total_… deaths_total_pe… active_total_pe…
    ##    <chr>     <date>                        <dbl>             <dbl>            <dbl>            <dbl>
    ##  1 Afghanis… 2020-04-09                       40                 3                1               36
    ##  2 Albania   2020-04-09                        9                11                1               -3
    ##  3 Algeria   2020-04-09                       94               110               30              -46
    ##  4 Andorra   2020-04-09                       19                 6                2               11
    ##  5 Angola    2020-04-09                        0                 0                0                0
    ##  6 Antigua … 2020-04-09                        0                 0                0                0
    ##  7 Argentina 2020-04-09                       80                 7                9               64
    ##  8 Armenia   2020-04-09                       40                24                1               15
    ##  9 Australia 2020-04-09                       98               392                1             -295
    ## 10 Austria   2020-04-09                      302               728               22             -448
    ## # … with 7,156 more rows

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

### Mortality rate

    ## # A tibble: 41 x 8
    ##    country observation_date first_confirmed… first_deaths_ca… recovered_total deaths_total
    ##    <chr>   <date>           <date>           <date>                     <dbl>        <dbl>
    ##  1 US      2020-04-09       2020-01-22       2020-02-29                 25410        16478
    ##  2 US      2020-04-08       2020-01-22       2020-02-29                 23559        14695
    ##  3 US      2020-04-07       2020-01-22       2020-02-29                 21763        12722
    ##  4 US      2020-04-06       2020-01-22       2020-02-29                 19581        10783
    ##  5 US      2020-04-05       2020-01-22       2020-02-29                 17448         9619
    ##  6 US      2020-04-04       2020-01-22       2020-02-29                 14652         8407
    ##  7 US      2020-04-03       2020-01-22       2020-02-29                  9707         7087
    ##  8 US      2020-04-02       2020-01-22       2020-02-29                  9001         5926
    ##  9 US      2020-04-01       2020-01-22       2020-02-29                  8474         4757
    ## 10 US      2020-03-31       2020-01-22       2020-02-29                  7024         3873
    ## # … with 31 more rows, and 2 more variables: confirmed_deaths_rate <dbl>,
    ## #   recovered_deaths_rate <dbl>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

## COVID-19 spread by countries population

    ## # A tibble: 70 x 5
    ##    country n_days_since_1st_confirmed population confirmed_total confirmed_total_per_1M
    ##    <chr>                        <dbl>      <int>           <dbl>                  <dbl>
    ##  1 Russia                          69  145934462           10131                   69.4
    ##  2 Russia                          68  145934462            8672                   59.4
    ##  3 Russia                          67  145934462            7497                   51.4
    ##  4 Russia                          66  145934462            6343                   43.5
    ##  5 Russia                          65  145934462            5389                   36.9
    ##  6 Russia                          64  145934462            4731                   32.4
    ##  7 Russia                          63  145934462            4149                   28.4
    ##  8 Russia                          62  145934462            3548                   24.3
    ##  9 Russia                          61  145934462            2777                   19.0
    ## 10 Russia                          60  145934462            2337                   16.0
    ## # … with 60 more rows

### TOPs countries by infected, active, and fatal cases

Calculate countries stats whose populations were most affected by the
virus:

#### …by infected cases

    ## # A tibble: 61 x 6
    ##    country   population confirmed_total confirmed_total_pe… n_days_since_1st_co… n_days_since_1st_d…
    ##    <chr>          <int>           <dbl>               <dbl>                <dbl>               <dbl>
    ##  1 Spain       46754778          153222               3277.                   68                  37
    ##  2 Switzerl…    8654622           24051               2779.                   44                  35
    ##  3 Italy       60461826          143626               2375.                   69                  48
    ##  4 Belgium     11589623           24983               2156.                   65                  29
    ##  5 France      65273511          118781               1820.                   76                  54
    ##  6 Austria      9006398           13244               1471.                   44                  28
    ##  7 Germany     83783942          118181               1411.                   72                  31
    ##  8 US         331002651          461437               1394.                   78                  40
    ##  9 Portugal    10196709           13956               1369.                   38                  23
    ## 10 Ireland      4937786            6574               1331.                   40                  29
    ## # … with 51 more rows

#### …by active cases

    ## # A tibble: 61 x 6
    ##    country    population active_total active_total_per_… n_days_since_1st_conf… n_days_since_1st_de…
    ##    <chr>           <int>        <dbl>              <dbl>                  <dbl>                <dbl>
    ##  1 Spain        46754778        85610              1831.                     68                   37
    ##  2 Italy        60461826        96877              1602.                     69                   48
    ##  3 Belgium      11589623        17296              1492.                     65                   29
    ##  4 Switzerla…    8654622        12503              1445.                     44                   35
    ##  5 Portugal     10196709        13342              1308.                     38                   23
    ##  6 France       65273511        83140              1274.                     76                   54
    ##  7 Ireland       4937786         6286              1273.                     40                   29
    ##  8 US          331002651       419549              1268.                     78                   40
    ##  9 Netherlan…   17134872        19222              1122.                     42                   34
    ## 10 Norway        5421241         6071              1120.                     43                   26
    ## # … with 51 more rows

#### …by fatal cases

    ## # A tibble: 61 x 6
    ##    country     population deaths_total deaths_total_per_… n_days_since_1st_conf… n_days_since_1st_d…
    ##    <chr>            <int>        <dbl>              <dbl>                  <dbl>               <dbl>
    ##  1 Spain         46754778        15447              330.                      68                  37
    ##  2 Italy         60461826        18279              302.                      69                  48
    ##  3 Belgium       11589623         2523              218.                      65                  29
    ##  4 France        65273511        12228              187.                      76                  54
    ##  5 Netherlands   17134872         2403              140.                      42                  34
    ##  6 United Kin…   67886011         7993              118.                      69                  35
    ##  7 Switzerland    8654622          948              110.                      44                  35
    ##  8 Sweden        10099265          793               78.5                     69                  29
    ##  9 Ireland        4937786          263               53.3                     40                  29
    ## 10 US           331002651        16478               49.8                     78                  40
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
