df_combi <- df_loci %>%
  select(locus) %>%
  rename(i=locus) %>%
  mutate(j=list(i)) %>%
  unnest(j) %>%
  filter(i!=j)
