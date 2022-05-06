library(patchwork)

model_ii_data <- read_tsv("data/cfu_clean.tsv") %>% 
  select(!c(plateID, Replicate, Dilution))


p1 <- ggplot(model_ii_data, 
             mapping = aes(x = Antibiotic, 
                           y = cfu_ml)) +
  geom_boxplot() +
  coord_flip()

p2 <- ggplot(model_ii_data, 
             mapping = aes(x = as_factor(Donor), 
                           y = cfu_ml)) +
  geom_boxplot() +
  coord_flip()  

p3 <- ggplot(model_ii_data) +
  geom_bar(mapping = aes(x = Antibiotic, 
                         y = cfu_ml), 
           stat = "identity") +
  facet_wrap(~Donor)

general_plot <- p3 | (p1 / p2)
general_plot  
