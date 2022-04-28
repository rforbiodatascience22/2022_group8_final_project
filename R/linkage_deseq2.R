sample_ij_function <- function(i,j){
  x_i <- df_loci_tidy %>%
    filter(locus==i) %>%
    pull(x)
  x_j <- df_loci_tidy %>%
    filter(locus==j) %>%
    pull(x)
  sample_ij <- tibble(x_i=x_i[[1]],x_j=x_j[[1]]) %>%
    mutate(valid=case_when(x_i==NA_integer_ | x_j==NA_integer_ ~ 0,
                         TRUE ~ 1)) %>%
    summarise(n=n())
  return(sample_ij)
}

s <- sample_ij_function("Rpi106","Rpi107")


df_combi <- df_loci %>%
  select(locus) %>%
  rename(i=locus) %>%
  mutate(j=list(i)) %>%
  unnest(j) %>%
  filter(i!=j) %>%
  rowwise %>%
  mutate(S_ij=sample_ij_function(i,j))
