

#'
#'
#'


# Import dependencies and read config ----
options(max.print = 1e3, scipen = 999, width = 1e2)
options(stringsAsFactors = F)

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(magrittr)
  
  library(stringr)
  library(lubridate)
  
  library(skimr)
  
  library(ggplot2)
})



## Params  ----
input_data_container <- "../input/novel-corona-virus-2019-dataset.zip"



## Load dataset  ----
print(
  as.character(unzip(input_data_container, list = T)$Name)
)

covid_data <- read.csv(unz(input_data_container, "covid_19_data.csv"), 
                       na.strings = c("NA", "None", ""),
                       header = T, sep = ",")

names(covid_data) <- names(covid_data) %>% str_replace_all(fixed("."), "_") %>% str_to_lower



## Preprocessing data ----
covid_data %<>% 
  rename(
    observation_date = observationdate
  ) %>% 
  mutate(
    # location processing
    province_state = str_trim(province_state),
    
    # dates processing
    observation_date = mdy(observation_date),
    last_update = parse_date_time(str_replace_all(last_update, "T", " "), 
                                  orders = c("%Y-%m-%d %H:%M:%S", "m/d/y %H:%M"))
  )
  

covid_data %>% as_tibble

covid_data %>% skim_tee



# Wuhan vs China vs Rest of World ----
## Prepare data
hu_ch_rof <- covid_data %>% 
  transmute(
    observation_date,

    area = as.factor(
      case_when(
        province_state == "Hubei" ~ "Hubei",
        country_region == "US" ~ "US",
        str_detect(country_region, "China") ~ "China without Hubei",
        TRUE ~ "Rest of World")),
    
    confirmed,
    deaths,
    recovered
  ) %>% 
  group_by(
    area, observation_date
  ) %>% 
  summarise(
    confirmed_total = sum(confirmed),
    deaths_total = sum(deaths),
    recovered_total = sum(recovered)
  ) %>% 
  mutate(deaths_total = -deaths_total)

hu_ch_rof


## Hubei, China (without Hubei), US, and Rest of World virus spread
ggplot(hu_ch_rof, aes(observation_date)) +
  
  geom_col(aes(y = recovered_total), alpha = .6, fill = "gold") +
  geom_col(aes(y = deaths_total), alpha = .6, fill = "black") +
  geom_line(aes(y = confirmed_total, color = area), alpha = .85, size = 1) +

  scale_x_date(date_labels = "%d %b", date_breaks = "7 days") +
  
  labs(x = "Date", y = "Number of cases", 
       title = "Spread of COVID-19", subtitle = "Virus spread by Hubei, China (without Hubei), US, and Rest of World \nGreen bar - recovered, black bar - death", 
       caption = "") +
  
  theme_bw() +
  theme(legend.position = "bottom", 
        legend.direction = "horizontal", 
        legend.title = element_blank())


  
  


