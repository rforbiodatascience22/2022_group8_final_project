## Create merged (OTU counts and mapfile) dataframe
merged_df <- read_tsv("data/otu_clean.tsv", show_col_types = FALSE) %>%
  pivot_longer(matches("A\\d{2}"), names_to = "SampleID", values_to = "count") %>%
  pivot_wider(id_cols = SampleID, names_from = family, values_from = count) %>%
  rename(Unknown="NA") %>%
  full_join(x=read_tsv("data/map_clean.tsv"), by = "SampleID")

write_tsv(merged_df, "data/otu_map_merged.tsv")