sample_ij_function <- function(i,j){
  x_i <- df_loci_tidy %>%
    filter(locus==i) %>%
    pull(x)
  x_j <- df_loci_tidy %>%
    filter(locus==j) %>%
    pull(x)
  sample_ij <- tibble(x_i=x_i[[1]],x_j=x_j[[1]]) %>%
    filter(!(is.na(x_i) | is.na(x_j))) %>%
    summarize(n=n()) %>%
    pull(n)
  return(sample_ij)
}

allele_combi_function <- function(i,j){
  j_alleles <- df_loci_tidy %>%
    filter(locus==j) %>%
    pull(unique_alleles)
  combis <- df_loci_tidy %>%
    filter(locus==i) %>%
    ungroup %>%
    select(unique_alleles) %>%
    rename(A=unique_alleles) %>%
    mutate(B=list(j_alleles)) %>%
    unnest(B)
  return(combis)
}

delta_AB_function <- function(i,j,A,B){
  
}


df_combi <- df_loci %>%
  select(locus) %>%
  rename(i=locus) %>%
  mutate(j=list(i)) %>%
  unnest(j) %>%
  filter(i!=j) %>%
  rowwise %>%
  mutate(S_ij=sample_ij_function(i,j)) %>%
  mutate(allele_combinations=list(allele_combi_function(i,j))) %>%
  unnest(allele_combinations) %>%
