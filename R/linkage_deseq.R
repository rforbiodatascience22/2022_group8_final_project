divide_alleles <-function (string){
  alleles <- (str_match_all(string, "\\d{3}"))
  return(alleles)
}

n_indiv <- f %>%
  summarise(n())

div_f <- f %>%
  mutate(across(!pop,divide_alleles))

allele_pairs_list=c()
total_alleles_list=c()
unique_alleles_list=c()
for (locus in loci_id){
  if (locus != "pop"){
    allele_pairs <- div_f %>%
      pull(locus) %>%
      list
    total_alleles <- allele_pairs %>%
      unlist
    total_alleles <- total_alleles[! total_alleles %in% "000"]
    unique_alleles <- total_alleles %>%
      unique
    allele_pairs_list=c(allele_pairs_list,allele_pairs)
    total_alleles_list=c(total_alleles_list,list(total_alleles))
    unique_alleles_list=c(unique_alleles_list,list(unique_alleles))
  }
}


df_loci <- loci_id %>%
  as_tibble_col(column_name = "locus") %>%
  filter(locus != "pop") %>%
  mutate(unique_alleles=unique_alleles_list,
         total_alleles=total_alleles_list,
         allele_pairs=allele_pairs_list)

df_loci_tidy <- df_loci %>%
  unnest(unique_alleles) %>%
  group_by(locus) %>%
  mutate(k=n(),
         freq=count(unique_alleles,total_alleles)/(n_indivs*2))
