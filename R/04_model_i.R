#families <- c(Ruminococcaceae,Enterobacteriaceae,Lachnospiraceae,Bifidobacteriaceae,Clostridiaceae,Erysipelotrichaceae,Bacteroidaceae,Coriobacteriaceae,Porphyromonadaceae,Enterococcaceae)

heat_map_data <- read_tsv("data/otu_map_merged.tsv", show_col_types = FALSE) %>%
  pivot_longer(c(Ruminococcaceae,Enterobacteriaceae,Lachnospiraceae,Bifidobacteriaceae,Clostridiaceae_1,Erysipelotrichaceae,Bacteroidaceae,Coriobacteriaceae,Porphyromonadaceae,Enterococcaceae),
               names_to = "family",
               values_to = "counts")

heat_map <- heat_map_data %>%
  ggplot(mapping = aes(Name, family)) +
  geom_tile(aes(fill = counts)) +
  facet_grid(cols = vars(Donor), space = "free_x")

heat_map

violin_1_A <- read_tsv("data/cfu_clean.tsv") %>%
  select(c(Donor, Community, Antibiotic, Replicate, cfu_ml))

violin_1_B <- filter_at(violin_1_A, vars(cfu_ml), all_vars((.) != 0))


ggplot(data = violin_1_B,
       mapping = aes(x = Antibiotic, 
                     y = cfu_ml,
                     fill = Community,
                     group = interaction(Antibiotic, Community))) +
  geom_violin() +
  geom_point(position = position_dodge(width=0.9))

  
