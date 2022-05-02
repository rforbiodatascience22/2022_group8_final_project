## Clean CFU counts dataframe
cfu_df_clean <- read_tsv("data/cfu.tsv")

write_tsv(cfu_df_clean, file='data/cfu_clean.tsv')


## Clean mapfile dataframe
map_df_clean <- read_tsv("data/map.tsv") %>%
  select(-c(Experiment,Platform,CycleKit,RunDate,Project,Treat,Description),-contains("Sequence")) %>%
  mutate(Donor=str_remove(Donor, "HumanDonor"))

write_tsv(map_df_clean, file='data/map_clean.tsv')


## Clean OTU counts dataframe
otu_df_clean <- read_tsv("data/otu.tsv") %>%
  mutate(`Consensus Lineage` = str_remove_all(`Consensus Lineage`, "[a-z]_{2}")) %>% 
  separate(col = `Consensus Lineage`, into = c('realm', 'phylum', 'class', 'order', 'family', 'genus', 'species'), sep = ';' ) %>% 
  select(-c(`#OTU ID`, genus, species, phylum, realm, class, order)) %>% 
  group_by(family) %>%
  summarise_all(sum)

write_tsv(otu_df_clean, file='data/otu_clean.tsv')