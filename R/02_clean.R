## Clean CFU counts dataframe
cfu_df_clean <- read_tsv("data/cfu.tsv", show_col_types = FALSE) %>%
  separate(Treatment, c("Donor","Community","Antibiotic"), sep="[CA]") %>%
  mutate(Donor = str_remove(Donor, "D")) %>%
  select(-c(total_cfu,Dilution)) %>%
  rename(cfu_ml = per_ml)
# Write tsv file
write_tsv(cfu_df_clean, file='data/cfu_clean.tsv')


## Clean mapfile dataframe
map_df_clean <- read_tsv("data/map.tsv", show_col_types = FALSE) %>%
  mutate(Donor=str_remove(Donor, "HumanDonor"),
         Treatment=case_when(Name=="Inoculum" ~ "Inoculum",
                             Antibiotic=="none" ~ "None",
                             TRUE ~ Antibiotic),
         Name=case_when(Name=="Inoculum" ~ Name,
                        TRUE ~ str_extract(Name, "\\d$"))) %>%
  rename(Replicate=Name) %>%
  select(c(SampleID,Donor,Replicate,Treatment))
# Write tsv file
write_tsv(map_df_clean, file='data/map_clean.tsv')


## Clean OTU counts dataframe
otu_df_clean <- read_tsv("data/otu.tsv", show_col_types = FALSE) %>%
  mutate(`Consensus Lineage` = str_remove_all(`Consensus Lineage`, "[a-z]_{2}")) %>%
  separate(col = `Consensus Lineage`, into = c('realm', 'phylum', 'class',
                                               'order', 'family', 'genus',
                                               'species'), sep = ";") %>%
  rename(OTU=`#OTU ID`) %>%
  rowwise() %>%
  filter(sum(across(matches("A\\d{2}")))>=5)
# Write tsv file
write_tsv(otu_df_clean, file='data/otu_clean.tsv')