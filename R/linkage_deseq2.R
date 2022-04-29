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

delta_AB_function <- function(i,j,A,B,S_ij){
  
  #Extract x vectors from df_loci_tidy
  x_A <- df_loci_tidy %>%
    ungroup %>%
    filter(locus==i & unique_alleles==A) %>%
    select(x) %>%
    unnest(x) %>%
    pull(x)
  x_B <- df_loci_tidy %>%
    ungroup %>%
    filter(locus==j & unique_alleles==B) %>%
    select(x) %>%
    unnest(x) %>%
    pull(x)

  #Remove samples with missing data in any of them
  x_A_B <- tibble(x_A=x_A,x_B=x_B) %>%
    filter(!(is.na(x_A) | is.na(x_B)))
  x_A <- x_A_B %>%
    pull(x_A)
  x_B <- x_A_B %>%
    pull(x_B)
  
  #Calculate delta following the formula from the algorithm
  delta_AB <- (S_ij/(S_ij-1))*(S_ij*sum(x_A*x_B)-sum(x_A)*sum(x_B))/(2*S_ij**2)
  return(delta_AB)
}

r_AB_function <- function(i,j,A,B,delta_AB){
  
  #Retrieve data (freq,h)
  freq_A <- df_loci_tidy %>%
    ungroup %>%
    filter(locus==i & unique_alleles==A) %>%
    pull(freq)
  h_A <- df_loci_tidy %>%
    ungroup %>%
    filter(locus==i & unique_alleles==A) %>%
    pull(h)
  freq_B <- df_loci_tidy %>%
    ungroup %>%
    filter(locus==j & unique_alleles==B) %>%
    pull(freq)
  h_B <- df_loci_tidy %>%
    ungroup %>%
    filter(locus==j & unique_alleles==B) %>%
    pull(h)
  
  #Calculate r_AB following the formula in the algorithm
  r_AB <- delta_AB/(sqrt((freq_A*(1-freq_A)+(h_A-freq_A**2))*(freq_B*(1-freq_B)+(h_B-freq_B**2))))
  return(r_AB)
}

n_ij_function <- function(i,j){
  ki <- df_loci_tidy %>%
    select(locus,k) %>%
    distinct %>%
    filter(locus==i) %>%
    pull(k)
  kj <- df_loci_tidy %>%
    select(locus,k) %>%
    distinct %>%
    filter(locus==j) %>%
    pull(k)
  
  n_ij <- (ki-1)*(kj-1)
  return(n_ij)
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
  rowwise %>%
  mutate(delta_AB=delta_AB_function(i,j,A,B,S_ij),
         r_AB=r_AB_function(i,j,A,B,delta_AB))

df_combi_tidy <- df_combi %>%
  group_by(i,j) %>%
  mutate(r_ij=mean(r_AB)) %>%
  select(-A,-B,-delta_AB,-r_AB) %>%
  distinct %>%
  mutate(n_ij=n_ij_function(i,j),
         w_ij=n_ij*(S_ij**2))
