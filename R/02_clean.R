## Clean CFU counts dataframe
cfu_df_clean <- read_tsv("data/cfu.tsv", show_col_types = FALSE) %>%
  separate(Treatment, c("Donor","Community","Antibiotic"), sep="[CA]") %>%              # separate "treatment" column into 3 by C and A
  mutate(Donor = str_remove(Donor, "D")) %>%                                            # leave only numbers in "donor" column
  select(-total_cfu,Dilution) %>%                                                       # select all columns but the ones specified
  rename(cfu_ml = per_ml)                                                               # rename column
# Write tsv file
write_tsv(cfu_df_clean, file='data/cfu_clean.tsv')


## Clean mapfile dataframe
map_df_clean <- read_tsv("data/map.tsv", show_col_types = FALSE) %>%                    # select all columns but the ones specified
  select(-c(Experiment,Platform,CycleKit,RunDate,Project,Treat),                    
         -contains("Sequence"),-contains("Index"),-contains("Description")) %>%
  mutate(Donor=str_remove(Donor, "HumanDonor"))                                         # keep only donor number
# Write tsv file
write_tsv(map_df_clean, file='data/map_clean.tsv')


## Clean OTU counts dataframe
otu_df_clean <- read_tsv("data/otu.tsv", show_col_types = FALSE) %>%
  mutate(`Consensus Lineage` = str_remove_all(`Consensus Lineage`, "[a-z]_{2}")) %>%   # remove low bars between taxons
  separate(col = `Consensus Lineage`, into = c('realm', 'phylum', 'class',             # and separate them by ";", giving new column names
                                               'order', 'family', 'genus',
                                               'species'), sep = ';' ) %>% 
  select(-c(`#OTU ID`, genus, species, phylum, realm, class, order)) %>%               # select all columns but the ones specified
  rowwise() %>%                                                                        # for each row
  filter(sum(across(matches("A\\d\\d")))>=5) %>%                                       # only select rows that the sum of all samples is greater than 5
  group_by(family) %>%
  summarise_all(sum)                                                                   # show only family and sample columns
# Write tsv file
write_tsv(otu_df_clean, file='data/otu_clean.tsv')