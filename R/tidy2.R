library(tidyverse)

raw_data <- read_lines("/cloud/project/data/Lithobates pipiens/Lithobates pipiens_LP1-A.txt", skip = 1) %>%
  as_tibble()

raw_data
match("pop", raw_data)