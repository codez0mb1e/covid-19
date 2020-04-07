#!/bin/sh


echo "Loading COVID Spread Dataset..."
kaggle datasets download -d sudalairajkumar/novel-corona-virus-2019-dataset -p ../data/

echo "Population by Country 2020 Dataset"
kaggle datasets download -d tanuprabhu/population-by-country-2020  -p ../data/

echo "Loading COVID-19 Global Forecasting Dataset"
kaggle competitions download -c covid19-global-forecasting-week-3 -p ../data/

echo "Loading Sberbank COVID-19 Global Forecast Dataset"
wget -P ../data/ https://storage.yandexcloud.net/datasouls-ods/materials/9a76eb73-0965-45b4-bf1d-4920aa317ba1/countries.csv.zip

echo "Loading quarantine_dates"
wget -P ../data/ https://raw.githubusercontent.com/tyz910/sberbank-covid19/master/data/quarantine_dates.csv

echo "WorldPopulationByAge2020"
wget -P ../data/ https://raw.githubusercontent.com/vlomme/sberbank-covid19-forecast-2020/master/WorldPopulationByAge2020.csv


echo "Completed."