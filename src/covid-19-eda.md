COVID-19 Analytics
================
17 April, 2020

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
    ##      SNo ObservationDate Province.State   Country.Region  Last.Update     Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>            <chr>           <chr>               <dbl>  <dbl>     <dbl>
    ##  1 14143 04/11/2020      Shanxi           Mainland China  2020-04-11 22:…       172      0       135
    ##  2  3387 03/04/2020      Sonoma County, … US              2020-03-02T20:…         1      0         0
    ##  3  1093 02/09/2020      Macau            Macau           2020-02-06T14:…        10      0         1
    ##  4 12291 04/06/2020      <NA>             Diamond Prince… 4/6/20 9:37           712     11       619
    ##  5  1297 02/12/2020      Xinjiang         Mainland China  2020-02-12T01:…        59      0         3
    ##  6 12409 04/06/2020      <NA>             Tanzania        4/6/20 9:37            24      1         3
    ##  7 11962 04/05/2020      <NA>             Chile           2020-04-05 23:…      4471     34       618
    ##  8  7794 03/22/2020      Channel Islands  UK              3/8/20 5:31            32      0         0
    ##  9  5918 03/16/2020      Chongqing        Mainland China  2020-03-15T03:…       576      6       570
    ## 10 15671 04/16/2020      Guizhou          Mainland China  2020-04-16 23:…       146      2       144
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

    ## # A tibble: 15,769 x 5
    ##    area          country        province_state observation_date confirmed
    ##    <fct>         <chr>          <chr>          <date>               <dbl>
    ##  1 US            US             New York       2020-04-16          223691
    ##  2 Rest of World Spain          <NA>           2020-04-16          184948
    ##  3 Rest of World Italy          <NA>           2020-04-16          168941
    ##  4 Rest of World France         <NA>           2020-04-16          145960
    ##  5 Rest of World Germany        <NA>           2020-04-16          137698
    ##  6 Rest of World UK             <NA>           2020-04-16          103093
    ##  7 Rest of World Iran           <NA>           2020-04-16           77995
    ##  8 US            US             New Jersey     2020-04-16           75317
    ##  9 Rest of World Turkey         <NA>           2020-04-16           74193
    ## 10 Hubei         Mainland China Hubei          2020-04-16           67803
    ## # … with 15,759 more rows

Get dataset structure after preprocessing:

|                                                  |            |
| :----------------------------------------------- | :--------- |
| Name                                             | Piped data |
| Number of rows                                   | 15769      |
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
| province\_state |       7832 |            0.5 |   2 |  43 |     0 |       295 |          0 |
| country         |          0 |            1.0 |   2 |  32 |     0 |       220 |          1 |

**Variable type:
Date**

| skim\_variable    | n\_missing | complete\_rate | min        | max        | median     | n\_unique |
| :---------------- | ---------: | -------------: | :--------- | :--------- | :--------- | --------: |
| observation\_date |          0 |              1 | 2020-01-22 | 2020-04-16 | 2020-03-22 |        86 |

**Variable type:
factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts                              |
| :------------- | ---------: | -------------: | :------ | --------: | :--------------------------------------- |
| area           |          0 |              1 | FALSE   |         4 | Res: 10029, US: 3076, Chi: 2578, Hub: 86 |

**Variable type:
numeric**

| skim\_variable | n\_missing | complete\_rate |    mean |       sd | p0 |  p25 |  p50 |   p75 |   p100 | hist  |
| :------------- | ---------: | -------------: | ------: | -------: | -: | ---: | ---: | ----: | -----: | :---- |
| sno            |          0 |              1 | 7885.00 |  4552.26 |  1 | 3943 | 7885 | 11827 |  15769 | ▇▇▇▇▇ |
| confirmed      |          0 |              1 | 2245.31 | 11977.67 |  0 |    7 |   76 |   525 | 223691 | ▇▁▁▁▁ |
| deaths         |          0 |              1 |  121.46 |  1001.35 |  0 |    0 |    1 |     6 |  22170 | ▇▁▁▁▁ |
| recovered      |          0 |              1 |  549.17 |  4386.89 |  0 |    0 |    1 |    43 |  77000 | ▇▁▁▁▁ |

**Variable type:
POSIXct**

| skim\_variable | n\_missing | complete\_rate | min                 | max                 | median              | n\_unique |
| :------------- | ---------: | -------------: | :------------------ | :------------------ | :------------------ | --------: |
| last\_update   |          0 |              1 | 2020-01-22 17:00:00 | 2020-04-16 23:38:19 | 2020-03-18 03:13:14 |      1826 |

### Preprocessing world population data

Get unmatched countries:

    ## # A tibble: 57 x 2
    ##    country                  n
    ##    <chr>                <dbl>
    ##  1 Mainland China     5486436
    ##  2 UK                 1222668
    ##  3 South Korea         422505
    ##  4 Czech Republic      109593
    ##  5 Others               26228
    ##  6 Hong Kong            24620
    ##  7 Diamond Princess     16376
    ##  8 Taiwan               10518
    ##  9 Ivory Coast           7767
    ## 10 West Bank and Gaza    4790
    ## # … with 47 more rows

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 52 x 2
    ##    country                n
    ##    <chr>              <dbl>
    ##  1 Others             26228
    ##  2 Hong Kong          24620
    ##  3 Diamond Princess   16376
    ##  4 Ivory Coast         7767
    ##  5 West Bank and Gaza  4790
    ##  6 Kosovo              4223
    ##  7 Macau               1590
    ##  8 Mali                1399
    ##  9 Burma                631
    ## 10 Guinea-Bissau        489
    ## # … with 42 more rows

Much better :)

## COVID-19 worldwide spread

***Analyze COVID-19 worldwide spread.***

### Total infected, recovered, and fatal cases

View spread statistics:

    ## # A tibble: 86 x 9
    ##    observation_date active_total active_total_de… confirmed_total confirmed_total… recovered_total
    ##    <date>                  <dbl> <chr>                      <dbl> <chr>                      <dbl>
    ##  1 2020-04-16            1466739 3.96%                    2152647 4.70%                     542107
    ##  2 2020-04-15            1410859 2.54%                    2056055 4.04%                     511019
    ##  3 2020-04-14            1375947 1.98%                    1976192 3.07%                     474261
    ##  4 2020-04-13            1349183 2.92%                    1917320 3.83%                     448655
    ##  5 2020-04-12            1310869 3.96%                    1846680 4.24%                     421722
    ##  6 2020-04-11            1260902 3.94%                    1771514 4.72%                     402110
    ##  7 2020-04-10            1213098 5.86%                    1691719 6.04%                     376096
    ##  8 2020-04-09            1145920 4.74%                    1595350 5.58%                     353975
    ##  9 2020-04-08            1094105 4.78%                    1511104 5.96%                     328661
    ## 10 2020-04-07            1044177 5.05%                    1426096 6.02%                     300054
    ## # … with 76 more rows, and 3 more variables: recovered_total_delta <chr>, deaths_total <dbl>,
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

    ## # A tibble: 3,643 x 10
    ##    country observation_date active_total active_total_de… confirmed_total confirmed_total…
    ##    <chr>   <date>                  <dbl> <chr>                      <dbl> <chr>           
    ##  1 US      2020-04-16             580182 4.36%                     667801 4.94%           
    ##  2 Italy   2020-04-16             106607 1.13%                     168941 2.29%           
    ##  3 France  2020-04-16              95823 11.52%                    147091 9.29%           
    ##  4 Spain   2020-04-16              90836 3.13%                     184948 4.11%           
    ##  5 United… 2020-04-16              90011 4.40%                     104145 4.69%           
    ##  6 Turkey  2020-04-16              65461 5.24%                      74193 6.92%           
    ##  7 Germany 2020-04-16              56646 -2.92%                    137698 2.19%           
    ##  8 Nether… 2020-04-16              25745 3.53%                      29383 3.77%           
    ##  9 Russia  2020-04-16              25402 13.88%                     27938 14.08%          
    ## 10 Belgium 2020-04-16              22390 1.65%                      34809 3.68%           
    ## # … with 3,633 more rows, and 4 more variables: recovered_total <dbl>, recovered_total_delta <chr>,
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

    ## # A tibble: 3,643 x 6
    ## # Groups:   country [127]
    ##    country  observation_date confirmed_total_p… recovered_total_p… deaths_total_pe… active_total_pe…
    ##    <chr>    <date>                        <dbl>              <dbl>            <dbl>            <dbl>
    ##  1 Afghani… 2020-04-16                       56                 11                5               40
    ##  2 Albania  2020-04-16                       24                 26                1               -3
    ##  3 Algeria  2020-04-16                      108                 75               12               21
    ##  4 Andorra  2020-04-16                        0                  0                0                0
    ##  5 Argenti… 2020-04-16                      128                 35                4               89
    ##  6 Armenia  2020-04-16                       48                 61                1              -14
    ##  7 Austral… 2020-04-16                       22                169                0             -147
    ##  8 Austria  2020-04-16                      140                888               17             -765
    ##  9 Azerbai… 2020-04-16                       30                 56                2              -28
    ## 10 Bahrain  2020-04-16                       29                 40                0              -11
    ## # … with 3,633 more rows

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

### Mortality rate

    ## # A tibble: 38 x 8
    ##    country observation_date since_100_confi… since_10_deaths… recovered_total deaths_total
    ##    <chr>   <date>           <date>           <date>                     <dbl>        <dbl>
    ##  1 US      2020-04-16       2020-03-10       2020-03-04                 54703        32916
    ##  2 US      2020-04-15       2020-03-10       2020-03-04                 52096        28325
    ##  3 US      2020-04-14       2020-03-10       2020-03-04                 47763        25831
    ##  4 US      2020-04-13       2020-03-10       2020-03-04                 43482        23528
    ##  5 US      2020-04-12       2020-03-10       2020-03-04                 32988        22019
    ##  6 US      2020-04-11       2020-03-10       2020-03-04                 31270        20462
    ##  7 US      2020-04-10       2020-03-10       2020-03-04                 28790        18586
    ##  8 US      2020-04-09       2020-03-10       2020-03-04                 25410        16478
    ##  9 US      2020-04-08       2020-03-10       2020-03-04                 23559        14695
    ## 10 US      2020-04-07       2020-03-10       2020-03-04                 21763        12722
    ## # … with 28 more rows, and 2 more variables: confirmed_deaths_rate <dbl>,
    ## #   recovered_deaths_rate <dbl>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

## COVID-19 spread by countries population

    ## # A tibble: 31 x 5
    ##    country n_days_since_100_confirmed population confirmed_total confirmed_total_per_1M
    ##    <chr>                        <dbl>      <int>           <dbl>                  <dbl>
    ##  1 Russia                          30  145934462           27938                  191. 
    ##  2 Russia                          29  145934462           24490                  168. 
    ##  3 Russia                          28  145934462           21102                  145. 
    ##  4 Russia                          27  145934462           18328                  126. 
    ##  5 Russia                          26  145934462           15770                  108. 
    ##  6 Russia                          25  145934462           13584                   93.1
    ##  7 Russia                          24  145934462           11917                   81.7
    ##  8 Russia                          23  145934462           10131                   69.4
    ##  9 Russia                          22  145934462            8672                   59.4
    ## 10 Russia                          21  145934462            7497                   51.4
    ## # … with 21 more rows

### TOPs countries by infected, active, and fatal cases

Calculate countries stats whose populations were most affected by the
virus:

#### …by infected cases

    ## # A tibble: 73 x 6
    ##    country   population confirmed_total confirmed_total_pe… n_days_since_100_co… n_days_since_10th_…
    ##    <chr>          <int>           <dbl>               <dbl>                <dbl>               <dbl>
    ##  1 Spain       46754778          184948               3956.                   45                  39
    ##  2 Switzerl…    8654622           26732               3089.                   42                  34
    ##  3 Belgium     11589623           34809               3003.                   41                  29
    ##  4 Italy       60461826          168941               2794.                   53                  50
    ##  5 Ireland      4937786           13271               2688.                   33                  21
    ##  6 France      65273511          147091               2253.                   46                  40
    ##  7 US         331002651          667801               2018.                   37                  43
    ##  8 Portugal    10196709           18841               1848.                   34                  26
    ##  9 Netherla…   17134872           29383               1715.                   41                  33
    ## 10 Germany     83783942          137698               1643.                   46                  32
    ## # … with 63 more rows

#### …by active cases

    ## # A tibble: 73 x 6
    ##    country     population active_total active_total_per_… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>            <int>        <dbl>              <dbl>                 <dbl>                <dbl>
    ##  1 Ireland        4937786        12708              2574.                    33                   21
    ##  2 Spain         46754778        90836              1943.                    45                   39
    ##  3 Belgium       11589623        22390              1932.                    41                   29
    ##  4 Italy         60461826       106607              1763.                    53                   50
    ##  5 US           331002651       580182              1753.                    37                   43
    ##  6 Portugal      10196709        17719              1738.                    34                   26
    ##  7 Netherlands   17134872        25745              1502.                    41                   33
    ##  8 France        65273511        95823              1468.                    46                   40
    ##  9 United Kin…   67886011        90011              1326.                    42                   33
    ## 10 Qatar          2881053         3681              1278.                    36                   NA
    ## # … with 63 more rows

#### …by fatal cases

    ## # A tibble: 73 x 6
    ##    country     population deaths_total deaths_total_per_… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>            <int>        <dbl>              <dbl>                 <dbl>                <dbl>
    ##  1 Belgium       11589623         4857              419.                     41                   29
    ##  2 Spain         46754778        19315              413.                     45                   39
    ##  3 Italy         60461826        22170              367.                     53                   50
    ##  4 France        65273511        17941              275.                     46                   40
    ##  5 United Kin…   67886011        13759              203.                     42                   33
    ##  6 Netherlands   17134872         3327              194.                     41                   33
    ##  7 Switzerland    8654622         1281              148.                     42                   34
    ##  8 Sweden        10099265         1333              132.                     41                   28
    ##  9 US           331002651        32916               99.4                    37                   43
    ## 10 Ireland        4937786          486               98.4                    33                   21
    ## # … with 63 more rows

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
