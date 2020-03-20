

#'
#'
#'



# Import dependencies and read config:
#```{r set_env_options}
options(max.print = 1e3, scipen = 999, width = 1e2)
options(stringsAsFactors = F)


# ```{r import_dependencies, echo=TRUE}
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


## Params
input_data_container <- "../input/novel-corona-virus-2019-dataset.zip"



## Load dataset
# ```{r load_dataset}
print(
  as.character(unzip(input_data_container, list = T)$Name)
)

open_line_list <- read.csv(unz(input_data_container, "COVID19_open_line_list.csv"), 
                           na.strings = c("NA", "N/A", ""),
                           header = T, sep = ",")

open_line_list %<>% 
  mutate(
    sex = case_when(
      str_to_lower(sex) == "male" ~ "M", 
      str_to_lower(sex) == "female" ~ "F",
      TRUE ~ NA_character_)
  ) %>% 
  mutate_at(
    vars(starts_with("date_")), 
    dmy
  ) %>% 
  select(matches("^[^X]"))

open_line_list %>% as_tibble
open_line_list %>% skim_tee

