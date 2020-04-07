#!/bin/sh


echo "Loading COVID Spread Dataset..."
kaggle datasets download -d sudalairajkumar/novel-corona-virus-2019-dataset -p ../input/

echo "Population by Country 2020 Dataset"
kaggle datasets download -d tanuprabhu/population-by-country-2020  -p ../input/

echo "Loading COVID-19 Global Forecasting Dataset"
kaggle competitions download -c covid19-global-forecasting-week-3 -p ../input/

echo "Loading Sberbank COVID-19 Global Forecast Dataset"
wget -P ../input/ https://storage.yandexcloud.net/datasouls-ods/materials/9a76eb73-0965-45b4-bf1d-4920aa317ba1/countries.csv.zip


echo "Completed."