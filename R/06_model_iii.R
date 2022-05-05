violin_1_A <- read_tsv("data/cfu_clean.tsv", show_col_types = FALSE) %>%
  select(c(Donor, Community, Antibiotic, Replicate, cfu_ml))

violin_1_B <- filter_at(violin_1_A, vars(cfu_ml), all_vars((.) != 0))



ggplot(data = violin_1_B,
       mapping = aes(x = Antibiotic, 
                     y = cfu_ml,
                     fill = Community,
                     group = interaction(Antibiotic, Community))) +
  geom_violin() +
  geom_point(position = position_dodge(width=0.9)) + 
  ylim(100000, 1000000000)
