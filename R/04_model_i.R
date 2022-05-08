library(tidyverse)
library(patchwork)

# Take data from the merged dataframe
heat_map_data <- read_tsv("data/otu_map_merged.tsv", show_col_types = FALSE) %>%
  rename(Clostridiaceae=Clostridiaceae_1) %>%
  pivot_longer(c(Ruminococcaceae,Enterobacteriaceae,Lachnospiraceae,                       
                 Bifidobacteriaceae,Clostridiaceae,Erysipelotrichaceae,
                 Bacteroidaceae,Coriobacteriaceae,Porphyromonadaceae,Enterococcaceae), 
               names_to = "family",
               values_to = "counts") %>%
  select(c(SampleID,Donor,Treatment,Replicate,family,counts)) %>%
  mutate(family=fct_reorder(family,counts,sum),
         Treatment = case_when(Treatment == "Inoculum" ~ "I",
                                Treatment == "None" ~ "AB free",
                                Treatment == "Polymyxin" ~ "Poly",
                                Treatment == "Rifampicin" ~ "Rif"),
         Treatment = fct_relevel(Treatment, "I", "AB free", "Poly", "Rif")) %>%
  group_by(SampleID) %>%
  mutate(counts_perc = 100*counts/sum(counts))

# Create 3 separate plots, as we don't know how to make 2 nested facets
h1 <- heat_map_data %>%
  filter(Donor==1) %>%
  ggplot(mapping = aes(Replicate, family)) +
  geom_tile(aes(fill = counts_perc), colour="white") +
  facet_grid(.~Treatment, scales = "free", space = "free", switch = "x") +
  theme_minimal() +
  labs(title = "Donor 1",
       x = NULL,
       y = NULL) +
  scale_fill_gradient2(name = "Abundance (%)",
                       low = "#336699",
                       high = "#FF3300", 
                       mid = "orange",
                       midpoint = 3,
                       trans = "pseudo_log",
                       limits = c(0,75)) +
  theme(plot.title = element_text(size = 2, hjust = 0.5),
        axis.text.y=element_text(size = 8),
        axis.text.x=element_blank(),
        legend.position = "none",
        panel.spacing = unit(0, "lines"),
        panel.grid.major = element_blank(),
        strip.text = element_text(size = 6))

h2 <- heat_map_data %>%
  filter(Donor==2) %>%
  ggplot(mapping = aes(Replicate, family)) +
  geom_tile(aes(fill = counts_perc), colour="white") +
  facet_grid(.~Treatment, scales = "free", space = "free", switch = "x") +
  theme_minimal() +
  labs(title = "Donor 2",
       x = "Treatment",
       y = NULL) +
  scale_fill_gradient2(name = "Abundance (%)",
                       low = "#336699",
                       high = "#FF3300",
                       mid = "orange", midpoint = 3,
                       trans = "pseudo_log",
                       limits = c(0,75)) +
  theme(plot.title = element_text(size = 2, hjust = 0.5),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        legend.position = "none",
        panel.spacing = unit(0, "lines"),
        plot.margin = margin(r=0, l=0),
        panel.grid.major = element_blank(),
        strip.text = element_text(size = 6))

h3 <- heat_map_data %>%
  filter(Donor==3) %>%
  ggplot(mapping = aes(Replicate, family)) +
  geom_tile(aes(fill = counts_perc), colour="white") +
  facet_grid(.~Treatment, scales = "free", space = "free", switch = "x") +
  theme_minimal() +
  labs(title = "Donor 3",
       x = NULL,
       y = NULL) +
  scale_fill_gradient2(name = "Abundance (%)",
                       low = "#336699",
                       high = "#FF3300",
                       mid = "orange",
                       midpoint = 3,
                       trans = "pseudo_log",
                       limits = c(0,75)) +
  theme(plot.title = element_text(size = 2, hjust = 0.5),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        panel.spacing = unit(0, "lines"),
        panel.grid.major = element_blank(),
        strip.text = element_text(size = 6),
        legend.title = element_text(size=8), #change legend title font size
        legend.text = element_text(size=8),
        strip.text.y = element_text(size = 6)) #change legend text font size)

# Merge plots with patchworks and save the final plot as .png
heat_map <- h1 | h2 | h3
heat_map + plot_annotation(
  title = 'Community response to antibiotic treatments',
  caption = 'Andrew D. Letten, Data obtained from Human-associated microbiota
  suppress invading bacteria even under disruption by antibiotics') &
  theme(plot.title = element_text(size = 10),
        axis.title = element_text(size = 8),
        plot.caption = element_text(size = 5))

ggsave("results/heatmap.png", width = 20, height = 12, units = "cm")
