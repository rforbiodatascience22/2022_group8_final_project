cfu_df_clean <- read_tsv("data/cfu.tsv")

map_df_clean <- read_tsv("data/map.tsv") %>%
  select(-c(Experiment,Platform,CycleKit,RunDate,Project,Treat,Description),-contains("Sequence")) %>%
  mutate(Donor=str_remove(Donor, "HumanDonor"))

otu_df_clean <- read_tsv("data/otu.tsv") %>% 
  as_tibble() %>%
  mutate(`Consensus Lineage` = str_remove_all(`Consensus Lineage`, "[:alpha:][:punct:]{2}")) %>% 
  separate(col = `Consensus Lineage`, into = c('realm', 'phylum', 'class', 'order', 'family', 'genus', 'species'), sep = ';' ) %>% 
  select(-c(`#OTU ID`, genus, species, phylum, realm, class, order)) %>% 
  group_by(family) %>%
  summarise_all(sum)

