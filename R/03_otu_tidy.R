data <- read_tsv("data/otu.tsv") %>% 
  as_tibble() %>% 
  mutate(`Consensus Lineage` = str_remove_all(`Consensus Lineage`, "[:alpha:][:punct:]{2}")) %>% 
  separate(col = `Consensus Lineage`, into = c('realm', 'phylum', 'class', 'order', 'family', 'genus', 'species'), sep = ';' ) %>% 
  select(-c(`#OTU ID`, genus, species, phylum, realm, class, order)) %>% 
  group_by(family) %>%
  summarise_all(sum)
data
?summarise_all
