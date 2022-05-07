library(phyloseq)

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
  mutate(count_perc = count/sum(count),
         log_count_perc = log(count_perc),
         mult=count_perc*log_count_perc,
         shannon = -sum(mult)) %>%
  select(c(SampleID,shannon)) %>%
  distinct

plot_iv_data <- read_tsv("data/map_clean.tsv", show_col_types = FALSE) %>%
  full_join(abundance_df, by = "SampleID") %>%
  full_join(richness_df, by = "SampleID") %>%
  full_join(shannon_df, by = "SampleID")
