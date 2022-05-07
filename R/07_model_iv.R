library(phyloseq)

cfu <- read_tsv("data/cfu_clean.tsv", show_col_types = FALSE) %>%
  #filter (Community == "+") %>%
  select(c(Donor, Antibiotic, cfu_ml)) %>%
  mutate(cfu_nl = cfu_ml*1e-6)

otu <- read_tsv("data/otu_map_merged.tsv", show_col_types = FALSE) %>%
  rowwise %>%
  mutate(sum=sum(across(-c(SampleID,Donor,Antibiotic,Time,Name)))) %>%
  select(c(SampleID,Donor,Antibiotic,Name,Time,sum))
  #mutate(cfu_nl = cfu_ml*1e-6)

#Calculate richness
read_tsv("data/otu.tsv", show_col_types = FALSE) %>%
  select(-c("#OTU ID","Consensus Lineage")) %>%
  rowwise() %>%
  filter(sum(across(matches("A\\d\\d")))>=5) %>%
  as.matrix %>%
  otu_table(T) %>%
  estimate_richness(measures=c("Observed"))

ggplot(data = cfu,
       mapping = aes(x = Antibiotic,
                     y = cfu_nl)) +
  geom_violin(mapping = aes(fill = Antibiotic)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             position = position_dodge(width = 0.4)) +
  labs(y = "Cells / nL")
