merge_Rifampicin <- read_tsv('data/otu_map_merged.tsv') %>%
  filter (Antibiotic == 'Rifampicin') %>%
  select(9:56) %>%
  sum()

merge_Polymyxin <- read_tsv('data/otu_map_merged.tsv') %>%
  filter (Antibiotic == 'Polymyxin', Donor ==1 ) %>%
  select(9:56) %>%
  slice(2) %>%
  sum()
  
print(10e-3*(merge_Polymyxin))  
 
cfu <- read_tsv("data/cfu_clean.tsv") %>%
  filter (Antibiotic == 'P', Donor == 2, Community == "-") %>%
  select(cfu_ml) %>%
  mutate(cfu_nl = cfu_ml*1e-6)

merge_none <- read_tsv('data/otu_map_merged.tsv') %>%
  filter (Antibiotic == 'none') %>%
  select(9:56) %>%
  sum()
