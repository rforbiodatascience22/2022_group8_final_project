library("tidyverse")

merge_Rifampicin <- read_tsv('data/otu_map_merged.tsv') %>%
  filter (Antibiotic == 'Rifampicin') %>%
  select(9:56) %>%
  sum()

merge_Polymyxin <- read_tsv('data/otu_map_merged.tsv') %>%
  filter (Antibiotic == 'Polymyxin') %>%
  select(9:56)
  #slice(3) %>%

  
print((merge_Polymyxin/3))  
 


merge_none <- read_tsv('data/otu_map_merged.tsv') %>%
  filter (Antibiotic == 'none') %>%
  select(9:56) %>%
  sum()


cfu <- read_tsv("data/cfu_clean.tsv") %>%
  #filter (Community == "+") %>%
  select(c(Donor, Community, Antibiotic, Replicate, cfu_ml)) %>%
  mutate(cfu_nl = cfu_ml*1e-6)

ggplot(data = cfu,
       mapping = aes(x = Antibiotic,
                     y = cfu_nl)) +
  geom_violin(mapping = aes(fill = Antibiotic)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             position = position_dodge(width = 0.3)
             )
             
             
             
