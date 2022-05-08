library(tidyverse)
library(phyloseq)

model_iv_data <- read_tsv("data/otu_clean.tsv", show_col_types = FALSE) %>%
  select(matches("A\\d{2}"))

# Calculate abundance
abundance_df <- model_iv_data %>%
  pivot_longer(matches("A\\d{2}"), names_to = "SampleID", values_to = "count") %>%
  group_by(SampleID) %>%
  mutate(Abundance=sum(count)) %>%
  select(c(SampleID, Abundance)) %>%
  distinct
  
# Calculate richness with phyloseq package (requires to work in base R for 3 lines)
richness_df <- model_iv_data %>%
  as.matrix %>%
  otu_table(TRUE) %>%
  estimate_richness(measures=c("Observed")) %>%
  as_tibble(rownames = "SampleID") %>%
  rename(Richness=Observed)

# Calculate Shannon Index
shannon_df <- model_iv_data %>%
  pivot_longer(matches("A\\d{2}"), names_to = "SampleID", values_to = "count") %>%
  group_by(SampleID) %>%
  filter(count!=0) %>%
  mutate(count_rel = count/sum(count),
         log_count_rel = log(count_rel),
         mult=count_rel*log_count_rel,
         Shannon = -sum(mult)) %>%
  select(c(SampleID, Shannon)) %>%
  distinct

#Combine values into one dataframe
plot_iv_data <- read_tsv("data/map_clean.tsv", show_col_types = FALSE) %>%
  full_join(abundance_df, by = "SampleID") %>%
  full_join(richness_df, by = "SampleID") %>%
  full_join(shannon_df, by = "SampleID") %>%
  mutate(Treatment = case_when(Treatment=="None" ~ "AB free",
                               TRUE ~ Treatment),
         Treatment = fct_relevel(Treatment,
                                 "Inoculum",
                                 "AB free",
                                 "Polymyxin",
                                 "Rifampicin")) %>%
  pivot_longer(c(Abundance, Richness, Shannon), names_to = "parameter", values_to = "value")

# Plotting violin plots for richness abundance and Shannon index

# Abundance
combi_violins_plot <- plot_iv_data %>%
  select(c(parameter, value, Treatment, Donor)) %>% 
  ggplot(mapping = aes(x = Treatment,
                     y = value)) +
  geom_violin(mapping = aes(fill = Treatment),
              alpha = 0.5,
              scale = "width",
              width = 0.3) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             color = "black",
             size = 2.5,
             position = position_dodge(width = 0.4)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor,
                           color = Treatment),
             position = position_dodge(width = 0.4)) +
  labs(y = "Diversity / Richness / Abundance",
       caption = "Andrew D. Letten, Human-associated microbiota
       suppress invading bacteria even under disruption by antibiotics") +
  scale_fill_manual(values = c("grey66", "#56B4E9", "#E69F00", "seagreen3"))+ 
  scale_colour_manual(values = c("grey66", "#56B4E9", "#E69F00", "seagreen3")) +
  facet_wrap(~parameter, dir="v", scales="free_y") +
  theme(legend.position = "none",
        axis.line = element_line(size=0.3),
        panel.background = element_blank(),
        strip.text = element_text(size=12),
        strip.background = element_blank())

ggsave("results/Ab_Ri_Sh.png", width = 15, height = 14, units = "cm")
