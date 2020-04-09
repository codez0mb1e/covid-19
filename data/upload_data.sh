#!/bin/sh


echo "Loading COVID Spread Datasets..."
kaggle datasets download -d sudalairajkumar/novel-corona-virus-2019-dataset -p ../data/

wget -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv
wget -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv
wget -P ../data/ https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv


echo "Loading Forecasting Datasets..."
kaggle competitions download -c covid19-global-forecasting-week-3 -p ../data/
wget -P ../data/ https://storage.yandexcloud.net/datasouls-ods/materials/9a76eb73-0965-45b4-bf1d-4920aa317ba1/countries.csv.zip


echo "Loading population by Country 2020 Datasets..."
kaggle datasets download -d tanuprabhu/population-by-country-2020  -p ../data/
wget -P ../data/ https://raw.githubusercontent.com/vlomme/sberbank-covid19-forecast-2020/master/WorldPopulationByAge2020.csv


echo "Loading quarantine_dates"
wget -P ../data/ https://raw.githubusercontent.com/tyz910/sberbank-covid19/master/data/quarantine_dates.csv


echo "Completed."