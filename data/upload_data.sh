#!/bin/sh


echo "Loading COVID spread datasets..."
kaggle datasets download -p ../data/ -d sudalairajkumar/novel-corona-virus-2019-dataset
kaggle competitions download -p ../data/ -c covid19-global-forecasting-week-4
kaggle datasets download -p ../data/ -d kapral42/covid19-russia-regions-cases

wget -N -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv
wget -N -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv
wget -N -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv
wget -N -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/web-data/data/cases_country.csv


echo "Loading socio demographic data..."
# Populations datasets
kaggle datasets download -p ../data/ -d tanuprabhu/population-by-country-2020
wget -N -P ../data/ https://storage.yandexcloud.net/datasouls-ods/materials/9a76eb73-0965-45b4-bf1d-4920aa317ba1/countries.csv.zip
wget -N -P ../data/ https://raw.githubusercontent.com/vlomme/sberbank-covid19-forecast-2020/master/data/WorldPopulationByAge2020.csv
kaggle datasets download -p ../data/ -d kwigan/reproduction-rate-russia-regions


echo "Loading mobility info..."
# Google mobility
wget -N -P ../data/ https://raw.githubusercontent.com/tyz910/sberbank-covid19/master/data/mobility-google.csv
# Apple mobility
wget -N -P ../data/ https://covid19-static.cdn-apple.com/covid19-mobility-data/2010HotfixDev27/v3/en-us/applemobilitytrends-2020-06-22.csv
# Yandex mobility
wget -N -P ../data/ https://raw.githubusercontent.com/tyz910/sberbank-covid19/master/data/mobility-yandex.csv

echo "Loading quarantine info..."
wget -N -P ../data/ https://raw.githubusercontent.com/tyz910/sberbank-covid19/master/data/quarantine.csv
kaggle datasets download -p ../data/ -d koryto/countryinfo


echo "Healtcare info..."
kaggle datasets download -p ../data/ -d danevans/world-bank-wdi-212-health-systems
kaggle datasets download -p ../data/ -d osciiart/smokingstats


echo "Completed."
