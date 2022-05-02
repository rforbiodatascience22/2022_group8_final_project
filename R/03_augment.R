map_df_clean <- read_tsv("data/map.tsv") %>%
  select(-c(Experiment,Platform,CycleKit,RunDate,Project,Treat,Description),-contains("Sequence")) %>%
  mutate(Donor=str_remove(Donor, "HumanDonor"))

merged_df <- read_tsv("data/otu.tsv") %>%
  rename(OTU=`#OTU ID`) %>%
  pivot_longer(matches("A\\d\\d"), names_to = "SampleID", values_to = "count") %>%
  pivot_wider(id_cols = SampleID, names_from = OTU, values_from = count) %>%
  full_join(map_df_clean, by = "SampleID")
