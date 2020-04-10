#!/bin/sh

datasets
echo "Loading COVID Spread datasets..."
kaggle datasets download -p ../data/ -d sudalairajkumar/novel-corona-virus-2019-dataset

wget -N -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv
wget -N -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv
wget -N -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv


echo "Loading Forecasting datasets..."
kaggle competitions download -p ../data/ -c covid19-global-forecasting-week-4
wget -N -P ../data/ https://storage.yandexcloud.net/datasouls-ods/materials/9a76eb73-0965-45b4-bf1d-4920aa317ba1/countries.csv.zip


echo "Loading population datasets..."
kaggle datasets download -p ../data/ -d tanuprabhu/population-by-country-2020
wget -N -P ../data/ https://raw.githubusercontent.com/vlomme/sberbank-covid19-forecast-2020/master/WorldPopulationByAge2020.csv
kaggle datasets download -p ../data/ -d osciiart/smokingstats


echo "Google mobility info..."
wget -N -P ../data/ https://raw.githubusercontent.com/tyz910/sberbank-covid19/master/data/mobility.csv


echo "Loading quarantine info..."
wget -N -P ../data/ https://raw.githubusercontent.com/tyz910/sberbank-covid19/master/data/quarantine_dates.csv
kaggle datasets download -p ../data/ -d koryto/countryinfo


echo "Healtcare info..."
kaggle datasets download -p ../data/ -d danevans/world-bank-wdi-212-health-systems


echo "Completed."