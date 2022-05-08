library(tidyverse)
library(patchwork)
library(scales)

model_ii_data <- read_tsv("data/cfu_clean.tsv", show_col_types = FALSE) %>% 
  select(!c(plateID, Replicate, Dilution))


p1 <- ggplot(model_ii_data, 
             mapping = aes(x = Antibiotic, 
                           y = cfu_ml,
                           fill = Antibiotic)) +
  geom_boxplot(alpha = 0.5) +
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
             mapping = aes(x = as_factor(Donor), 
                           y = cfu_ml,
                           fill = as_factor(Donor))) +
  geom_boxplot(alpha = 0.5) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor =  element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank()) +
  scale_fill_discrete(name = "Donor") +
  coord_flip()  

p3 <- ggplot(model_ii_data) +
  geom_bar(mapping = aes(x = Antibiotic, 
                         y = cfu_ml), 
           stat = "identity") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor =  element_blank(),
        panel.background = element_blank()) +
  facet_wrap(~Donor) + 
  theme_minimal()+
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x)))

general_plot <- (p3 | (p1 / p2)) +   
  plot_annotation(
    title = "Focal strain growth",
    subtitle = "Figures showing different E. coli counts by treatment and donor",
    caption = "Data from Letten, A. et al. 2021",
    tag_levels = "A")
  
general_plot  
ggsave("results/general_plot.png")  
