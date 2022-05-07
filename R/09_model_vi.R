library(phyloseq)

#Calculate richness
richness <- read_tsv("data/otu.tsv", show_col_types = FALSE) %>%
  select(-c("#OTU ID","Consensus Lineage")) %>%
  rowwise() %>%
  filter(sum(across(matches("A\\d\\d")))>=5) %>%
  as.matrix %>%
  otu_table(T) %>%
  estimate_richness(measures=c("Observed")) %>%
  as_tibble(rownames = "SampleID") %>%
  left_join(otu) 

richness_plot <- richness %>%
  mutate(Treatment = case_when(Name %in% c("Rifampicin 1", "Rifampicin 2", "Rifampicin 3") ~ "Rifampicin",
                               Name %in% c("Polymyxin 1","Polymyxin 2","Polymyxin 3") ~"Polymyxin",
                               Name %in% c("None 1", "None 2", "None 3") ~ "AB free",
                               Name %in% c("Inoculum") ~ "Inoculum")) %>%
  select(c(Observed, Treatment, Donor))

ggplot(data = richness_plot,
       mapping = aes(x = Treatment,
                     y = Observed)) +
  geom_violin(mapping = aes(fill = Treatment)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             position = position_dodge(width = 0.4)) +
  labs(y = "Richness") +
  theme(axis.title.x = element_blank())