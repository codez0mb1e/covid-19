COVID-19 Analytics
================
26 October, 2020

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

Get list of files in datasets container:

    ## [1] "COVID19_line_list_data.csv"            "COVID19_open_line_list.csv"           
    ## [3] "covid_19_data.csv"                     "time_series_covid_19_confirmed.csv"   
    ## [5] "time_series_covid_19_confirmed_US.csv" "time_series_covid_19_deaths.csv"      
    ## [7] "time_series_covid_19_deaths_US.csv"    "time_series_covid_19_recovered.csv"

Load `covid_19_data.csv` dataset:

    ## # A tibble: 100 x 8
    ##       SNo ObservationDate Province.State    Country.Region Last.Update    Confirmed Deaths Recovered
    ##     <int> <chr>           <chr>             <chr>          <chr>              <dbl>  <dbl>     <dbl>
    ##  1  54847 07/02/2020      Anguilla          UK             2020-07-03 04…         3      0         3
    ##  2  88850 08/17/2020      California        US             2020-08-18 04…    629415  11296         0
    ##  3  92115 08/21/2020      Omsk Oblast       Russia         2020-08-22 04…      8893    145      6800
    ##  4  83707 08/10/2020      Dnipropetrovsk O… Ukraine        2020-08-11 04…      1571     33      1132
    ##  5  39638 06/11/2020      Delaware          US             2020-06-12 05…     10106    414         0
    ##  6   1154 02/10/2020      <NA>              Singapore      2020-02-10T19…        45      0         2
    ##  7   8766 03/25/2020      Ohio              US             2020-03-25 23…       704     11         0
    ##  8 116140 09/23/2020      <NA>              Jamaica        2020-09-24 04…      5395     76      1444
    ##  9  35811 06/05/2020      Texas             US             2020-06-06 02…     72548   1812         0
    ## 10  99925 09/01/2020      Andhra Pradesh    India          2020-09-02 04…    445139   4053    339876
    ## # … with 90 more rows

### Load world population data

Get datasets list:

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

    ## # A tibble: 116,805 x 5
    ##    area          country      province_state observation_date confirmed
    ##    <fct>         <chr>        <chr>          <date>               <dbl>
    ##  1 Rest of World India        Maharashtra    2020-09-23         1242770
    ##  2 Rest of World Brazil       Sao Paulo      2020-09-23          945422
    ##  3 US            US           California     2020-09-23          796436
    ##  4 US            US           Texas          2020-09-23          742913
    ##  5 US            US           Florida        2020-09-23          690499
    ##  6 Rest of World South Africa <NA>           2020-09-23          665188
    ##  7 Rest of World Argentina    <NA>           2020-09-23          664799
    ##  8 Rest of World India        Andhra Pradesh 2020-09-23          639302
    ##  9 Rest of World India        Tamil Nadu     2020-09-23          552674
    ## 10 Rest of World India        Karnataka      2020-09-23          533850
    ## # … with 116,795 more rows

### Preprocessing world population data

Get unmatched countries:

    ## # A tibble: 60 x 2
    ##    country                   n
    ##    <chr>                 <dbl>
    ##  1 UK                 47036878
    ##  2 Mainland China     18897448
    ##  3 South Korea         2717610
    ##  4 Czech Republic      2692681
    ##  5 Ivory Coast         1637533
    ##  6 West Bank and Gaza  1493451
    ##  7 Kosovo               890826
    ##  8 Tajikistan           869268
    ##  9 Hong Kong            410886
    ## 10 Malawi               390307
    ## # … with 50 more rows

Correct top of unmached countries.

And updated matching:

    ## # A tibble: 55 x 2
    ##    country                  n
    ##    <chr>                <dbl>
    ##  1 Ivory Coast        1637533
    ##  2 West Bank and Gaza 1493451
    ##  3 Kosovo              890826
    ##  4 Tajikistan          869268
    ##  5 Hong Kong           410886
    ##  6 Malawi              390307
    ##  7 Mali                310458
    ##  8 South Sudan         264326
    ##  9 Guinea-Bissau       248246
    ## 10 Sierra Leone        211625
    ## # … with 45 more rows

Much better :)

## COVID-19 worldwide spread

***Analyze COVID-19 worldwide spread.***

### Total infected, recovered, and fatal cases

View spread statistics:

    ## # A tibble: 246 x 9
    ##    observation_date active_total active_total_de… confirmed_total confirmed_total… recovered_total
    ##    <date>                  <dbl> <chr>                      <dbl> <chr>                      <dbl>
    ##  1 2020-09-23            8914289 -0.10%                  31779835 0.83%                   21890442
    ##  2 2020-09-22            8923075 0.40%                   31517087 0.87%                   21624434
    ##  3 2020-09-21            8887511 0.81%                   31245797 1.00%                   21394593
    ##  4 2020-09-20            8815987 0.07%                   30935011 0.80%                   21159459
    ##  5 2020-09-19            8810095 0.43%                   30688150 0.93%                   20922189
    ##  6 2020-09-18            8772567 0.90%                   30406197 1.09%                   20683110
    ##  7 2020-09-17            8694289 1.10%                   30078889 1.06%                   20439713
    ##  8 2020-09-16            8599363 0.65%                   29764055 0.70%                   20225219
    ##  9 2020-09-15            8544111 0.66%                   29557942 1.26%                   20078979
    ## 10 2020-09-14            8488492 0.66%                   29190841 1.00%                   19775100
    ## # … with 236 more rows, and 3 more variables: recovered_total_delta <chr>, deaths_total <dbl>,
    ## #   deaths_total_delta <chr>

### Dynamics of spread

![](covid-19-eda_files/figure-gfm/worldwide_spread_over_time-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

### Disease cases structure

![](covid-19-eda_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

### Dynamics of daily cases

Get daily dynamics of new infected and recovered cases.

World daily spread:

    ## # A tibble: 7 x 5
    ##   observation_date confirmed_total_per_… deaths_total_per_d… recovered_total_per… active_total_per_…
    ##   <date>                           <dbl>               <dbl>                <dbl>              <dbl>
    ## 1 2020-09-17                      314834                5414               214494              94926
    ## 2 2020-09-04                      304626                5636               204681              94309
    ## 3 2020-08-21                      270751                5554               170679              94518
    ## 4 2020-08-13                      275227                6001               164494             104732
    ## 5 2020-07-23                      281417                9953               169899             101565
    ## 6 2020-07-22                      282312                7000               176997              98315
    ## 7 2020-07-19                      214569                4029                87836             122704

![](covid-19-eda_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

## COVID-19 spread by countries

***Analyze COVID-19 spread y countries.***

### Infected, recovered, fatal, and active cases

Calculate number of infected, recovered, fatal, and active (infected
cases minus recovered and fatal) cases grouped by country:

Get countries ordered by total active cases:

    ## # A tibble: 30,055 x 10
    ##    country observation_date active_total active_total_de… confirmed_total confirmed_total…
    ##    <chr>   <date>                  <dbl> <chr>                      <dbl> <chr>           
    ##  1 US      2020-09-23            4061408 0.32%                    6933548 0.54%           
    ##  2 India   2020-09-23             968377 -0.77%                   5646010 1.50%           
    ##  3 Spain   2020-09-23             512146 2.23%                     693556 1.65%           
    ##  4 Brazil  2020-09-23             406432 -6.87%                   4591364 0.00%           
    ##  5 France  2020-09-23             380511 -0.07%                    508456 0.26%           
    ##  6 United… 2020-09-23             368047 1.71%                     412245 1.52%           
    ##  7 Russia  2020-09-23             177165 0.29%                    1117487 0.57%           
    ##  8 Argent… 2020-09-23             124937 3.26%                     664799 1.94%           
    ##  9 Peru    2020-09-23             108489 -16.35%                   776546 1.00%           
    ## 10 Ukraine 2020-09-23             100937 1.70%                     189488 1.94%           
    ## # … with 30,045 more rows, and 4 more variables: recovered_total <dbl>,
    ## #   recovered_total_delta <chr>, deaths_total <dbl>, deaths_total_delta <chr>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

### Dynamics of spread

![](covid-19-eda_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

### Dynamics of daily cases

Get daily dynamics of new infected and recovered cases by countries.

World daily spread:

    ## # A tibble: 30,055 x 6
    ## # Groups:   country [178]
    ##    country  observation_date confirmed_total_p… recovered_total_p… deaths_total_pe… active_total_pe…
    ##    <chr>    <date>                        <dbl>              <dbl>            <dbl>            <dbl>
    ##  1 Afghani… 2020-09-23                       49                 34                1               14
    ##  2 Albania  2020-09-23                      121                 97                3               21
    ##  3 Algeria  2020-09-23                      186                121                9               56
    ##  4 Andorra  2020-09-23                       72                  4                0               68
    ##  5 Angola   2020-09-23                      127                 11                4              112
    ##  6 Argenti… 2020-09-23                    12625               8258              424             3943
    ##  7 Armenia  2020-09-23                      210                350                4             -144
    ##  8 Austral… 2020-09-23                        8                117                2             -111
    ##  9 Austria  2020-09-23                      681                637                6               38
    ## 10 Azerbai… 2020-09-23                      146                173                2              -29
    ## # … with 30,045 more rows

![](covid-19-eda_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

### Mortality rate

    ## # A tibble: 198 x 8
    ##    country observation_date since_100_confi… since_10_deaths… recovered_total deaths_total
    ##    <chr>   <date>           <date>           <date>                     <dbl>        <dbl>
    ##  1 US      2020-09-23       2020-03-10       2020-03-04               2670256       201884
    ##  2 US      2020-09-22       2020-03-10       2020-03-04               2646959       200786
    ##  3 US      2020-09-21       2020-03-10       2020-03-04               2615949       199865
    ##  4 US      2020-09-20       2020-03-10       2020-03-04               2590671       199509
    ##  5 US      2020-09-19       2020-03-10       2020-03-04               2577446       199282
    ##  6 US      2020-09-18       2020-03-10       2020-03-04               2556465       198570
    ##  7 US      2020-09-17       2020-03-10       2020-03-04               2540334       197633
    ##  8 US      2020-09-16       2020-03-10       2020-03-04               2525573       196763
    ##  9 US      2020-09-15       2020-03-10       2020-03-04               2495127       195781
    ## 10 US      2020-09-14       2020-03-10       2020-03-04               2474570       194493
    ## # … with 188 more rows, and 2 more variables: confirmed_deaths_rate <dbl>,
    ## #   recovered_deaths_rate <dbl>

![](covid-19-eda_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

![](covid-19-eda_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

## COVID-19 spread by countries population

    ## # A tibble: 191 x 5
    ##    country n_days_since_100_confirmed population confirmed_total confirmed_total_per_1M
    ##    <chr>                        <dbl>      <int>           <dbl>                  <dbl>
    ##  1 Russia                         190  145934462         1117487                  7657.
    ##  2 Russia                         189  145934462         1111157                  7614.
    ##  3 Russia                         188  145934462         1105048                  7572.
    ##  4 Russia                         187  145934462         1098958                  7530.
    ##  5 Russia                         186  145934462         1092915                  7489.
    ##  6 Russia                         185  145934462         1086955                  7448.
    ##  7 Russia                         184  145934462         1081152                  7408.
    ##  8 Russia                         183  145934462         1075485                  7370.
    ##  9 Russia                         182  145934462         1069873                  7331.
    ## 10 Russia                         181  145934462         1064438                  7294.
    ## # … with 181 more rows

### TOPs countries by infected, active, and fatal cases

Calculate countries stats whose populations were most affected by the
virus:

#### …by infected cases

    ## # A tibble: 133 x 6
    ##    country population confirmed_total confirmed_total_pe… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>        <int>           <dbl>               <dbl>                 <dbl>                <dbl>
    ##  1 Qatar      2881053          124175              43101.                   196                  145
    ##  2 Bahrain    1701575           67014              39384.                   197                  131
    ##  3 Panama     4314767          107990              25028.                   188                  179
    ##  4 Kuwait     4270571          101299              23720.                   193                  155
    ##  5 Israel     8655535          204690              23648.                   196                  180
    ##  6 Peru      32971854          776546              23552.                   190                  180
    ##  7 Chile     19116201          449903              23535.                   191                  176
    ##  8 Brazil   212559417         4591364              21600.                   194                  187
    ##  9 US       331002651         6933548              20947.                   197                  203
    ## 10 Oman       5106626           95339              18670.                   181                  146
    ## # … with 123 more rows

#### …by active cases

    ## # A tibble: 133 x 6
    ##    country     population active_total active_total_per_… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>            <int>        <dbl>              <dbl>                 <dbl>                <dbl>
    ##  1 US           331002651      4061408             12270.                   197                  203
    ##  2 Spain         46754778       512146             10954.                   205                  199
    ##  3 Sweden        10099265        83880              8306.                   201                  188
    ##  4 Costa Rica     5094118        41142              8076.                   186                  107
    ##  5 Israel         8655535        58402              6747.                   196                  180
    ##  6 Belgium       11589623        77849              6717.                   201                  189
    ##  7 France        65273511       380511              5829.                   206                  200
    ##  8 Netherlands   17134872        95817              5592.                   201                  193
    ##  9 United Kin…   67886011       368047              5422.                   202                  193
    ## 10 Panama         4314767        21262              4928.                   188                  179
    ## # … with 123 more rows

#### …by fatal cases

    ## # A tibble: 133 x 6
    ##    country     population deaths_total deaths_total_per_… n_days_since_100_con… n_days_since_10th_d…
    ##    <chr>            <int>        <dbl>              <dbl>                 <dbl>                <dbl>
    ##  1 Peru          32971854        31568               957.                   190                  180
    ##  2 Belgium       11589623         9959               859.                   201                  189
    ##  3 Spain         46754778        31034               664.                   205                  199
    ##  4 Bolivia       11673021         7731               662.                   176                  170
    ##  5 Brazil       212559417       138105               650.                   194                  187
    ##  6 Chile         19116201        12345               646.                   191                  176
    ##  7 Ecuador       17643054        11171               633.                   189                  185
    ##  8 United Kin…   67886011        41951               618.                   202                  193
    ##  9 US           331002651       201884               610.                   197                  203
    ## 10 Italy         60461826        35758               591.                   213                  210
    ## # … with 123 more rows

### Active cases per 1 million population vs number of days since 100th infected case

Select countries to monitoring:

    ##  [1] "Belgium"        "Costa Rica"     "France"         "Israel"         "Netherlands"   
    ##  [6] "Panama"         "Spain"          "Sweden"         "United Kingdom" "US"            
    ## [11] "Russia"         "Mainland China"

![](covid-19-eda_files/figure-gfm/active-cases-dynamics-1.png)<!-- -->

### Active cases per 1 million population vs number of days since 10th fatal case

![](covid-19-eda_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

*Take Care and Stay Healthy\!*
