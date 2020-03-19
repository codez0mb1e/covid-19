

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



## Preprocessing data ----

names(covid_data) <- names(covid_data) %>% str_replace_all(fixed("."), "_") %>% str_to_lower

covid_data %<>% 
  rename(observation_date = observationdate) %>% 
  mutate(
    ## location processing
    province_state = str_trim(province_state),
    area = as.factor(
      case_when(
        province_state == "Hubei" ~ "Hubei",
        country_region == "US" ~ "US",
        str_detect(country_region, "China") ~ "China without Hubei",
        TRUE ~ "Rest of World")),
    
    ## dates processing
    observation_date = mdy(observation_date),
    last_update = parse_date_time(str_replace_all(last_update, "T", " "), 
                                  orders = c("%Y-%m-%d %H:%M:%S", "m/d/y %H:%M"))
  )
  

covid_data %>% as_tibble

covid_data %>% skim_tee



# Wuhan vs China vs Rest of World ----
## Prepare data
spread_df <- covid_data %>% 
  group_by(
    area, observation_date
  ) %>% 
  summarise(
    confirmed_total = sum(confirmed),
    deaths_total = sum(deaths),
    recovered_total = sum(recovered)
  ) %>% 
  mutate(deaths_total = -deaths_total)

spread_df


## Hubei, China (without Hubei), US, and Rest of World virus spread
ggplot(spread_df, aes(observation_date)) +
  
  geom_col(aes(y = recovered_total), alpha = .6, fill = "gold") +
  geom_col(aes(y = deaths_total), alpha = .6, fill = "black") +
  geom_line(aes(y = confirmed_total, color = area), alpha = .85, size = 1) +

  scale_x_date(date_labels = "%d %b", date_breaks = "7 days") +
  
  labs(x = "", y = "Number of cases", 
       title = "COVID-19 Spread", 
       subtitle = "Virus spread by Hubei, China (without Hubei), US, and Rest of World \nGreen bar - recovered cases, black bar - deaths cases.", 
       caption = "") +
  
  theme_minimal() +
  theme(legend.position = "top", 
        legend.direction = "horizontal", 
        legend.title = element_blank())


  
# Mortality rate ----

## Prepare data
mortality_df <- covid_data %>% 
  group_by(area, observation_date) %>% 
  summarise(
    confirmed_total = sum(confirmed),
    deaths_total = sum(deaths),
    recovered_total = sum(recovered)
  ) %>% 
  ungroup() %>% 
  inner_join(
    covid_data %>% 
      filter(deaths > 0) %>% 
      group_by(area) %>% 
      summarise(first_observation_date = min(observation_date)),
    by = "area"
  ) %>% 
  mutate(
    confirmed_deaths_rate = deaths_total/confirmed_total,
    recovered_deaths_total = deaths_total/recovered_total,
    n_days = observation_date %>% difftime(first_observation_date, units = "days") %>% as.numeric
  ) %>% 
  filter(n_days >= 0)


mortality_df %>% 
  filter(area == "US") %>% 
  arrange(desc(observation_date)) %>% 
  select(observation_date, n_days, confirmed_total, recovered_total, deaths_total, confirmed_deaths_rate, recovered_deaths_total)



## Mortality rate visualization
ggplot(mortality_df, aes(x = n_days)) +
  geom_area(aes(y = recovered_deaths_total), alpha = .5, fill = "grey") +
  geom_area(aes(y = confirmed_deaths_rate), alpha = .75, fill = "black") +
  
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  
  facet_wrap(area ~ ., scales = "free") +
  
  labs(x = "Number of days from 1-st deaths case", y = "Mortality rate", 
       title = "COVID-19 Mortality Rate", 
       subtitle = "Rate by Hubei, China (without Hubei), US, and Rest of World \nGrey area - deaths to recovered cases, black area - deaths to confirmed cases", 
       caption = "") +
  
  theme_minimal()
  

ggplot(mortality_df, aes(x = n_days)) +
  geom_line(aes(y = confirmed_deaths_rate, color = area), size = 1, alpha = .75) +
  
  geom_hline(aes(yintercept = mean(mortality_df$confirmed_deaths_rate)), linetype = "dashed", color = "red", alpha = .75) +
  annotate(geom = "text", label = "Mean mortality rate (all time)", x = 4, y = mean(mortality_df$confirmed_deaths_rate), vjust = -1) +

  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  
  labs(x = "Number of days from 1-st deaths case", y = "Mortality rate", 
       title = "COVID-19 Mortality Rate", 
       subtitle = "Rate by Hubei, China (without Hubei), US, and Rest of World", 
       caption = "") +
  
  theme_minimal() +
  theme(legend.position = "top", 
        legend.title = element_blank())

