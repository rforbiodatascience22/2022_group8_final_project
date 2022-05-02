map_df_clean <- read_tsv("data/map.tsv") %>%
  select(-c(Experiment,Platform,CycleKit,RunDate,Project,Treat,Description))
