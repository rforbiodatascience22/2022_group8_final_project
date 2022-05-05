#Load libraries
library(tidyverse)
library(patchwork)

data <- cfu_df_clean
p1 <- ggplot(data, 
             mapping = aes(x = Antibiotic, 
                           y = cfu_ml)) +
  geom_boxplot() +
  coord_flip()

p2 <- ggplot(data, 
             mapping = aes(x = Donor, 
                           y = cfu_ml)) +
  geom_boxplot() +
  coord_flip()  

p3 <- ggplot(data) +
  geom_bar(mapping = aes(x = Antibiotic, 
                         y = cfu_ml), 
           stat = "identity") +
  facet_wrap(~Donor)

p3 | (p1 / p2)
  