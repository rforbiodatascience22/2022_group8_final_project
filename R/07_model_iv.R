cfu <- read_tsv("data/cfu_clean.tsv") %>%
  #filter (Community == "+") %>%
  select(c(Donor, Antibiotic, cfu_ml)) %>%
  mutate(cfu_nl = cfu_ml*1e-6)

otu <- read_tsv("data/otu_map_merged.tsv") %>%
    select(c(9:52)) %>%
    slice (1) %>%
    sum()
    #mutate(cfu_nl = cfu_ml*1e-6)




ggplot(data = cfu,
       mapping = aes(x = Antibiotic,
                     y = cfu_nl)) +
  geom_violin(mapping = aes(fill = Antibiotic)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             position = position_dodge(width = 0.4)) +
  labs(y = "Cells / nL")
