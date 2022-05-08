library(patchwork)

model_ii_data <- read_tsv("data/cfu_clean.tsv", show_col_types = FALSE) %>% 
  select(!c(plateID, Replicate, Dilution))


p1 <- ggplot(model_ii_data, 
             mapping = aes(x = Antibiotic, 
                           y = cfu_ml)) +
  geom_boxplot() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank()) +
  coord_flip()

p2 <- ggplot(model_ii_data, 
             mapping = aes(x = as_factor(Donor), 
                           y = cfu_ml)) +
  geom_boxplot() +
  labs(x = "Donor") +
  coord_flip()  

p3 <- ggplot(model_ii_data) +
  geom_bar(mapping = aes(x = Antibiotic, 
                         y = cfu_ml), 
           stat = "identity") +
  facet_wrap(~Donor)

general_plot <- (p3 | (p1 / p2)) +   
  plot_annotation(
    title = "Focal strain growth by donor and treatment",
    caption = "Data from Andrew D. Letten. Human-associated microbiota
    suppress invading bacteria even under disruption by antibiotics.",
    tag_levels = "A")
    
ggsave("results/general_plot.png")  
