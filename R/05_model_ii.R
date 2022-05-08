library(tidyverse)
library(patchwork)
library(scales)

model_ii_data <- read_tsv("data/cfu_clean.tsv", show_col_types = FALSE) %>% 
  select(-c(plateID, Replicate, Dilution)) %>%
  group_by(Donor, Antibiotic) %>%
  mutate(mean_rep = mean(cfu_ml)) %>%
  mutate(Antibiotic = recode(Antibiotic,
                             "R" = "Rifampicin",
                             "P" = "Polymyxin",
                             "-" = "No Treatment")) %>%
  distinct(mean_rep) %>%
  rename(cfu_ml = mean_rep) %>%
  drop_na()


p1 <- ggplot(model_ii_data, 
             mapping = aes(x = Antibiotic, 
                           y = cfu_ml,
                           fill = Antibiotic)) +
  geom_boxplot(alpha = 0.5) +
  scale_fill_manual(values = c("#56B4E9", "#E69F00", "seagreen3")) +
  labs(y = "CFU mL-1") +
  theme(axis.title.x = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor =  element_blank(),
        panel.background = element_blank(),
        axis.line.y = element_line(),
        axis.title.y = element_blank()) +
  coord_flip()

p2 <- ggplot(model_ii_data, 
             mapping = aes(y = as_factor(Donor), 
                           x = cfu_ml,
                           fill = as_factor(Donor))) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "CFU mL-1") +
  scale_fill_manual(name = "Donor", values = c("#B5C933", "#8C7035", "#439B98")) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor =  element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank()) 


p3 <- ggplot(model_ii_data) +
  geom_bar(mapping = aes(x = Antibiotic, 
                         y = cfu_ml,
                         fill = Antibiotic),
           alpha = 0.6,
           stat = "identity") +
  scale_fill_manual(values = c("#56B4E9", "#E69F00", "seagreen3"))+
  labs(y = "CFU mL-1") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1,
                                   vjust = 1.5),
        legend.position = "none") +
    facet_wrap(~Donor) 


general_plot <- (p3 | (p1 / p2)) +
  plot_annotation(
    title = "Focal strain growth",
    subtitle = "Figures showing different E. coli counts by treatment and donor",
    caption = "Andrew D. Letten,Human-associated microbiota
       suppress invading bacteria even under disruption by antibiotics",
    tag_levels = "A",
    theme = theme(plot.title = element_text(size = 18)))

general_plot  
ggsave("results/general_plot.png", width = 20, height = 12, units = "cm")