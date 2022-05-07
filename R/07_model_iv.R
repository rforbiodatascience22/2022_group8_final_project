library(phyloseq)
library(patchwork)

model_iv_data <- read_tsv("data/otu.tsv", show_col_types = FALSE) %>%
  select(-c(`#OTU ID`,`Consensus Lineage`)) %>%
  rowwise() %>%
  filter(sum(across(matches("A\\d{2}")))>=5)

#Calculate abundance
abundance_df <- model_iv_data %>%
  pivot_longer(matches("A\\d{2}"), names_to = "SampleID", values_to = "count") %>%
  group_by(SampleID) %>%
  mutate(abundance=sum(count)) %>%
  select(c(SampleID,abundance)) %>%
  distinct
  

#Calculate richness with phyloseq package (requires to turn to base R for 3 lines)
richness_df <- model_iv_data %>%
  as.matrix %>%
  otu_table(T) %>%
  estimate_richness(measures=c("Observed")) %>%
  as_tibble(rownames = "SampleID") %>%
  rename(richness=Observed)


#Calculate Shannon Index
shannon_df <- model_iv_data %>%
  pivot_longer(matches("A\\d{2}"), names_to = "SampleID", values_to = "count") %>%
  group_by(SampleID) %>%
  filter(count!=0) %>%
  mutate(count_rel = count/sum(count),
         log_count_rel = log(count_rel),
         mult=count_rel*log_count_rel,
         shannon = -sum(mult)) %>%
  select(c(SampleID,shannon)) %>%
  distinct

plot_iv_data <- read_tsv("data/map_clean.tsv", show_col_types = FALSE) %>%
  full_join(abundance_df, by = "SampleID") %>%
  full_join(richness_df, by = "SampleID") %>%
  full_join(shannon_df, by = "SampleID") %>% 
  mutate(treatment = case_when(Name %in% c("Rifampicin 1", "Rifampicin 2", "Rifampicin 3") ~ "Rifampicin",
                               Name %in% c("Polymyxin 1","Polymyxin 2","Polymyxin 3") ~"Polymyxin",
                               Name %in% c("None 1", "None 2", "None 3") ~ "AB free",
                               Name %in% c("Inoculum") ~ "Inoculum"))
  
plot_iv_data


# Plotting violin plots for richness abundance and Shannon index
#Abundance
abundance_plot <- plot_iv_data %>%
  select(c(abundance, treatment, Donor)) %>% 
  #filter(treatment != "Inoculum") %>% 
  ggplot(mapping = aes(x = treatment,
                     y = abundance)) +
  geom_violin(mapping = aes(fill = treatment)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             position = position_dodge(width = 0.4)) +
  labs(y = "Abundance") +
  theme(axis.title.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line.y = element_line(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "none")
        
abundance_plot
# Richness
richness_plot <- plot_iv_data %>%
  select(c(richness, treatment, Donor)) %>%  
  ggplot(mapping = aes(x = treatment,
                       y = richness)) +
  geom_violin(mapping = aes(fill = treatment)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             position = position_dodge(width = 0.4)) +
  labs(y = "Richness") +
  theme(axis.title.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line.y = element_line(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "none")
richness_plot
# Shannon index
shannon_plot <- plot_iv_data %>%
  select(c(shannon, treatment, Donor)) %>%  
  ggplot(mapping = aes(x = treatment,
                       y = shannon)) +
  geom_violin(mapping = aes(fill = treatment)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             position = position_dodge(width = 0.4)) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(),
        legend.position = "none") +
  labs(y = "Shannon")
shannon_plot

# Combining plots

combined_violins <- abundance_plot / richness_plot / shannon_plot +
  plot_layout(guides = "collect")
combined_violins
