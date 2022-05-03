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



  
