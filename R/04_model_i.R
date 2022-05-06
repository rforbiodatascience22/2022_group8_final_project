library(tidyverse)
library(patchwork)

#families <- c(Ruminococcaceae,Enterobacteriaceae,Lachnospiraceae,Bifidobacteriaceae,Clostridiaceae,Erysipelotrichaceae,Bacteroidaceae,Coriobacteriaceae,Porphyromonadaceae,Enterococcaceae)

heat_map_data <- read_tsv("data/otu_map_merged.tsv", show_col_types = FALSE) %>%
  rename(Clostridiaceae=Clostridiaceae_1) %>%
  pivot_longer(c(Ruminococcaceae,Enterobacteriaceae,Lachnospiraceae,Bifidobacteriaceae,Clostridiaceae,Erysipelotrichaceae,Bacteroidaceae,Coriobacteriaceae,Porphyromonadaceae,Enterococcaceae),
               names_to = "family",
               values_to = "counts") %>%
  mutate(Antibiotic = case_when(Time == "0h" ~ "0h",
                                Antibiotic == "none" ~ "AB free",
                                Antibiotic == "Polymyxin" ~ "Poly",
                                Antibiotic == "Rifampicin" ~ "Rif"),
         Replicate = str_extract(Name,"\\d"))

heat_map_data_1 <- heat_map_data %>%
  filter(Donor==1)

heat_map_data_2 <- heat_map_data %>%
  filter(Donor==2)

heat_map_data_3 <- heat_map_data %>%
  filter(Donor==3)

h1 <- heat_map_data_1 %>%
  ggplot(mapping = aes(Replicate, family)) +
  geom_raster(aes(fill = counts)) +
  facet_grid(.~Antibiotic, scales = "free", space = "free", switch = "x") +
  theme_minimal() +
  labs(title = "Donor 1",
       x = NULL,
       y = NULL) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x=element_blank(),
        legend.position = "none",
        panel.spacing = unit(0, "lines"))

h2 <- heat_map_data_2 %>%
  ggplot(mapping = aes(Replicate, family)) +
  geom_raster(aes(fill = counts)) +
  facet_grid(.~Antibiotic, scales = "free", space = "free", switch = "x") +
  theme_minimal() +
  labs(title = "Donor 2",
       x = "Treatment",
       y = NULL) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        legend.position = "none",
        panel.spacing = unit(0, "lines"),
        plot.margin = margin(t=0, r=0, b=0, l=0))

h3 <- heat_map_data_3 %>%
  ggplot(mapping = aes(Replicate, family)) +
  geom_raster(aes(fill = counts)) +
  facet_grid(.~Antibiotic, scales = "free", space = "free", switch = "x") +
  theme_minimal() +
  labs(title = "Donor 3",
       x = NULL,
       y = NULL) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        panel.spacing = unit(0, "lines"))

heat_map <- h1 | h2 | h3

ggsave("results/heatmap.png")
