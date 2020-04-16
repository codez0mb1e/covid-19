COVID-19 Analytics
================
16 April, 2020

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
    ##      SNo ObservationDate Province.State   Country.Region Last.Update      Confirmed Deaths Recovered
    ##    <int> <chr>           <chr>            <chr>          <chr>                <dbl>  <dbl>     <dbl>
    ##  1 14971 04/14/2020      <NA>             Syria          2020-04-14 23:4…        29      2         5
    ##  2  9945 03/29/2020      Guadeloupe       France         3/8/20 5:31            106      4        17
    ##  3 13990 04/11/2020      <NA>             San Marino     2020-04-11 22:5…       356     35        53
    ##  4 11517 04/03/2020      Guizhou          Mainland China 2020-04-03 22:5…       146      2       144
    ##  5 12543 04/06/2020      Shanxi           Mainland China 4/6/20 9:37            138      0       133
    ##  6  2120 02/23/2020      Jiangsu          Mainland China 2020-02-23T08:5…       631      0       418
    ##  7  6818 03/19/2020      Liaoning         Mainland China 2020-03-18T02:1…       125      1       122
    ##  8 14223 04/12/2020      <NA>             Eritrea        2020-04-12 23:2…        34      0         0
    ##  9  4981 03/12/2020      Shanxi           Mainland China 2020-03-12T09:1…       133      0       132
    ## 10  3966 03/07/2020      Madera County, … US             2020-03-07T20:1…         1      0         0
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

    ## # A tibble: 15,131 x 5
    ##    area          country        province_state observation_date confirmed
    ##    <fct>         <chr>          <chr>          <date>               <dbl>
    ##  1 US            US             New York       2020-04-14          203020
    ##  2 Rest of World Spain          <NA>           2020-04-14          172541
    ##  3 Rest of World Italy          <NA>           2020-04-14          162488
    ##  4 Rest of World Germany        <NA>           2020-04-14          131359
    ##  5 Rest of World France         <NA>           2020-04-14          130253
    ##  6 Rest of World UK             <NA>           2020-04-14           93873
    ##  7 Rest of World Iran           <NA>           2020-04-14           74877
    ##  8 US            US             New Jersey     2020-04-14           68824
    ##  9 Hubei         Mainland China Hubei          2020-04-14           67803
    ## 10 Rest of World Turkey         <NA>           2020-04-14           65111
    ## # … with 15,121 more rows

Get dataset structure after preprocessing:

|                                                  |            |
| :----------------------------------------------- | :--------- |
| Name                                             | Piped data |
| Number of rows                                   | 15131      |
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
| province\_state |       7470 |           0.51 |   2 |  43 |     0 |       295 |          0 |
| country         |          0 |           1.00 |   2 |  32 |     0 |       220 |          1 |

**Variable type:
Date**

| skim\_variable    | n\_missing | complete\_rate | min        | max        | median     | n\_unique |
| :---------------- | ---------: | -------------: | :--------- | :--------- | :--------- | --------: |
| observation\_date |          0 |              1 | 2020-01-22 | 2020-04-14 | 2020-03-21 |        84 |

**Variable type:
factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts                             |
| :------------- | ---------: | -------------: | :------ | --------: | :-------------------------------------- |
| area           |          0 |              1 | FALSE   |         4 | Res: 9567, US: 2962, Chi: 2518, Hub: 84 |

**Variable type:
numeric**

| skim\_variable | n\_missing | complete\_rate |    mean |       sd | p0 |    p25 |  p50 |     p75 |   p100 | hist  |
| :------------- | ---------: | -------------: | ------: | -------: | -: | -----: | ---: | ------: | -----: | :---- |
| sno            |          0 |              1 | 7566.00 |  4368.09 |  1 | 3783.5 | 7566 | 11348.5 |  15131 | ▇▇▇▇▇ |
| confirmed      |          0 |              1 | 2061.84 | 11189.20 |  0 |    6.0 |   72 |   481.0 | 203020 | ▇▁▁▁▁ |
| deaths         |          0 |              1 |  108.21 |   913.50 |  0 |    0.0 |    1 |     5.0 |  21067 | ▇▁▁▁▁ |
| recovered      |          0 |              1 |  502.73 |  4117.61 |  0 |    0.0 |    1 |    37.0 |  68200 | ▇▁▁▁▁ |

**Variable type:
POSIXct**

| skim\_variable | n\_missing | complete\_rate | min                 | max                 | median              | n\_unique |
| :------------- | ---------: | -------------: | :------------------ | :------------------ | :------------------ | --------: |
| last\_update   |          0 |              1 | 2020-01-22 17:00:00 | 2020-04-14 23:41:11 | 2020-03-16 20:13:20 |      1824 |

### Preprocessing world population data

Get unmatched countries:

    ## # A tibble: 57 x 2
    ##    country                  n
    ##    <chr>                <dbl>
    ##  1 Mainland China     5321801
    ##  2 UK                 1019040
    ##  3 South Korea         401301
    ##  4 Czech Republic       96944
    ##  5 Others               26228
    ##  6 Hong Kong            22586
    ##  7 Diamond Princess     14952
    ##  8 Taiwan                9728
    ##  9 Ivory Coast           6475
    ## 10 West Bank and Gaza    4042
    ## # … with 47 more rows

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 52 x 2
    ##    country                n
    ##    <chr>              <dbl>
    ##  1 Others             26228
    ##  2 Hong Kong          22586
    ##  3 Diamond Princess   14952
    ##  4 Ivory Coast         6475
    ##  5 West Bank and Gaza  4042
    ##  6 Kosovo              3387
    ##  7 Macau               1500
    ##  8 Mali                1080
    ##  9 Burma                472
    ## 10 Guinea-Bissau        403
    ## # … with 42 more rows

Much better :)

## COVID-19 worldwide spread

***Analyze COVID-19 worldwide spread.***

### Total infected, recovered, and fatal cases

View spread statistics:

    ## # A tibble: 84 x 9
    ##    observation_date active_total active_total_de… confirmed_total confirmed_total… recovered_total
    ##    <date>                  <dbl> <chr>                      <dbl> <chr>                      <dbl>
    ##  1 2020-04-14            1375946 1.98%                    1976192 3.07%                     474261
    ##  2 2020-04-13            1349182 2.92%                    1917320 3.83%                     448655
    ##  3 2020-04-12            1310868 3.96%                    1846680 4.24%                     421722
    ##  4 2020-04-11            1260901 3.94%                    1771514 4.72%                     402110
    ##  5 2020-04-10            1213098 5.86%                    1691719 6.04%                     376096
    ##  6 2020-04-09            1145920 4.74%                    1595350 5.58%                     353975
    ##  7 2020-04-08            1094105 4.78%                    1511104 5.96%                     328661
    ##  8 2020-04-07            1044177 5.05%                    1426096 6.02%                     300054
    ##  9 2020-04-06             994021 5.44%                    1345101 5.74%                     276515
    ## 10 2020-04-05             942729 6.32%                    1272115 6.24%                     260012
    ## # … with 74 more rows, and 3 more variables: recovered_total_delta <chr>, deaths_total <dbl>,
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
    ## 1 2020-04-10                       96369                7070                22121              67178
    ## 2 2020-04-05                       74707                4768                13860              56079
    ## 3 2020-04-04                      101491                5819                20356              75316
    ## 4 2020-04-03                       82614                5804                15533              61277
    ## 5 2020-04-02                       80698                6174                17092              57432
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

    ## # A tibble: 3,391 x 10
    ##    country observation_date active_total active_total_de… confirmed_total confirmed_total…
    ##    <chr>   <date>                  <dbl> <chr>                      <dbl> <chr>           
    ##  1 US      2020-04-14             534075 3.98%                     607670 4.66%           
    ##  2 Italy   2020-04-14             104291 0.65%                     162488 1.86%           
    ##  3 Spain   2020-04-14              86981 -0.72%                    172541 1.44%           
    ##  4 France  2020-04-14              86515 -8.82%                    131361 -4.72%          
    ##  5 United… 2020-04-14              82393 5.74%                      94845 5.89%           
    ##  6 Germany 2020-04-14              59865 -4.34%                    131359 0.99%           
    ##  7 Turkey  2020-04-14              58909 5.58%                      65111 6.65%           
    ##  8 Nether… 2020-04-14              24328 3.16%                      27580 3.26%           
    ##  9 Iran    2020-04-14              22065 -2.95%                     74877 2.15%           
    ## 10 Brazil  2020-04-14              20684 -5.68%                     25262 7.82%           
    ## # … with 3,381 more rows, and 4 more variables: recovered_total <dbl>, recovered_total_delta <chr>,
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

    ## # A tibble: 3,391 x 6
    ## # Groups:   country [125]
    ##    country  observation_date confirmed_total_p… recovered_total_p… deaths_total_pe… active_total_pe…
    ##    <chr>    <date>                        <dbl>              <dbl>            <dbl>            <dbl>
    ##  1 Afghani… 2020-04-14                       49                  8                2               39
    ##  2 Albania  2020-04-14                        8                 16                1               -9
    ##  3 Algeria  2020-04-14                       87                 90               13              -16
    ##  4 Andorra  2020-04-14                       13                  0                2               11
    ##  5 Argenti… 2020-04-14                       69                 44                5               20
    ##  6 Armenia  2020-04-14                       28                 54                2              -28
    ##  7 Austral… 2020-04-14                       64                380                1             -317
    ##  8 Austria  2020-04-14                      185                290               16             -121
    ##  9 Azerbai… 2020-04-14                       49                 62                1              -14
    ## 10 Bahrain  2020-04-14                      167                 54                1              112
    ## # … with 3,381 more rows

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

    ## `geom_smooth()` using formula 'y ~ x'

![](covid-19-eda_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

### Mortality rate

    ## # A tibble: 36 x 8
    ##    country observation_date since_100_confi… since_10_deaths… recovered_total deaths_total
    ##    <chr>   <date>           <date>           <date>                     <dbl>        <dbl>
    ##  1 US      2020-04-14       2020-03-10       2020-03-04                 47763        25832
    ##  2 US      2020-04-13       2020-03-10       2020-03-04                 43482        23529
    ##  3 US      2020-04-12       2020-03-10       2020-03-04                 32988        22020
    ##  4 US      2020-04-11       2020-03-10       2020-03-04                 31270        20463
    ##  5 US      2020-04-10       2020-03-10       2020-03-04                 28790        18586
    ##  6 US      2020-04-09       2020-03-10       2020-03-04                 25410        16478
    ##  7 US      2020-04-08       2020-03-10       2020-03-04                 23559        14695
    ##  8 US      2020-04-07       2020-03-10       2020-03-04                 21763        12722
    ##  9 US      2020-04-06       2020-03-10       2020-03-04                 19581        10783
    ## 10 US      2020-04-05       2020-03-10       2020-03-04                 17448         9619
    ## # … with 26 more rows, and 2 more variables: confirmed_deaths_rate <dbl>,
    ## #   recovered_deaths_rate <dbl>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

## COVID-19 spread by countries population

    ## # A tibble: 29 x 5
    ##    country n_days_since_100_confirmed population confirmed_total confirmed_total_per_1M
    ##    <chr>                        <dbl>      <int>           <dbl>                  <dbl>
    ##  1 Russia                          28  145934462           21102                  145. 
    ##  2 Russia                          27  145934462           18328                  126. 
    ##  3 Russia                          26  145934462           15770                  108. 
    ##  4 Russia                          25  145934462           13584                   93.1
    ##  5 Russia                          24  145934462           11917                   81.7
    ##  6 Russia                          23  145934462           10131                   69.4
    ##  7 Russia                          22  145934462            8672                   59.4
    ##  8 Russia                          21  145934462            7497                   51.4
    ##  9 Russia                          20  145934462            6343                   43.5
    ## 10 Russia                          19  145934462            5389                   36.9
    ## # … with 19 more rows

### TOPs countries by infected, active, and fatal cases

Calculate countries stats whose populations were most affected by the
virus:

#### …by infected cases

    ## # A tibble: 71 x 6
    ##    country   population confirmed_total confirmed_total_pe… n_days_since_100_co… n_days_since_10th_…
    ##    <chr>          <int>           <dbl>               <dbl>                <dbl>               <dbl>
    ##  1 Spain       46754778          172541               3690.                   43                  37
    ##  2 Switzerl…    8654622           25936               2997.                   40                  32
    ##  3 Italy       60461826          162488               2687.                   51                  48
    ##  4 Belgium     11589623           31119               2685.                   39                  27
    ##  5 Ireland      4937786           11479               2325.                   31                  19
    ##  6 France      65273511          131361               2012.                   44                  38
    ##  7 US         331002651          607670               1836.                   35                  41
    ##  8 Portugal    10196709           17448               1711.                   32                  24
    ##  9 Netherla…   17134872           27580               1610.                   39                  31
    ## 10 Austria      9006398           14226               1580.                   37                  23
    ## # … with 61 more rows

#### …by active cases

    ## # A tibble: 71 x 6
    ##    country     population active_total active_total_per_… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>            <int>        <dbl>              <dbl>                 <dbl>                <dbl>
    ##  1 Ireland        4937786        11048              2237.                    31                   19
    ##  2 Spain         46754778        86981              1860.                    43                   37
    ##  3 Belgium       11589623        20094              1734.                    39                   27
    ##  4 Italy         60461826       104291              1725.                    51                   48
    ##  5 Portugal      10196709        16534              1622.                    32                   24
    ##  6 US           331002651       534075              1614.                    35                   41
    ##  7 Netherlands   17134872        24328              1420.                    39                   31
    ##  8 France        65273511        86515              1325.                    44                   38
    ##  9 Switzerland    8654622        11062              1278.                    40                   32
    ## 10 United Kin…   67886011        82393              1214.                    40                   31
    ## # … with 61 more rows

#### …by fatal cases

    ## # A tibble: 71 x 6
    ##    country     population deaths_total deaths_total_per_… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>            <int>        <dbl>              <dbl>                 <dbl>                <dbl>
    ##  1 Spain         46754778        18056              386.                     43                   37
    ##  2 Belgium       11589623         4157              359.                     39                   27
    ##  3 Italy         60461826        21067              348.                     51                   48
    ##  4 France        65273511        15748              241.                     44                   38
    ##  5 United Kin…   67886011        12129              179.                     40                   31
    ##  6 Netherlands   17134872         2955              172.                     39                   31
    ##  7 Switzerland    8654622         1174              136.                     40                   32
    ##  8 Sweden        10099265         1033              102.                     39                   26
    ##  9 Ireland        4937786          406               82.2                    31                   19
    ## 10 US           331002651        25832               78.0                    35                   41
    ## # … with 61 more rows

### Active cases per 1 million population vs number of days since 100th infected case

Select countries to
    monitoring:

    ##  [1] "Belgium"        "France"         "Ireland"        "Italy"          "Netherlands"   
    ##  [6] "Portugal"       "Spain"          "Switzerland"    "United Kingdom" "US"            
    ## [11] "Russia"         "Mainland China" "Korea, South"

![](covid-19-eda_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

### Active cases per 1 million population vs number of days since 10th fatal case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->

***Stay healthy. Help the sick.***
