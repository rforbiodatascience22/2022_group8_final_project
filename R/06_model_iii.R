violin_1_A_data <- read_tsv("data/cfu_clean.tsv", show_col_types = FALSE) %>%
  select(c(Donor, Community, Antibiotic, Replicate, cfu_ml)) %>%
  mutate(cfu_ml = na_if(cfu_ml, 0) ) %>%
  drop_na()


violin_1_A <- ggplot(data = violin_1_A_data,
       mapping = aes(x = Antibiotic,
                     y = cfu_ml)) +
  geom_violin(mapping = aes(fill = Community)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = interaction(Donor, Community)),
             position = position_dodge(width = 0.75)) +
  scale_y_log10() 

ggsave("results/violin_1_A.png")




