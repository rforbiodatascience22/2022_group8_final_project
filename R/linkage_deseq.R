divide_alleles <-function (string){
  if (length(string)==2){
    
  }
  if (length(string)==3){
    alleles <- (str_match_all(string, "\\d{3}"))
  }
  return(alleles)
}

freq_function <- function(unique, total){
  freq <- 0
  for (i in total[[1]]){
    if (unique==i){
      freq <- freq + 1
    }
  }
  freq <- freq/length(total[[1]])
  return(freq)
}

homo_freq_function <- function(unique, pairs){
  freq <- 0
  for (i in pairs[[1]]){
    if (i[[1]]==unique & i[[2]]==unique){
      freq <- freq + 1
    }
  }
  freq <- freq/length(pairs[[1]])
  return(freq)
}

x_vector_function <- function(unique, pairs){
  x <- c()
  for (i in pairs[[1]]){
    if (i[[1]]=='000'){
      x <- append(x,'none')
    } else if (i[[1]]==unique & i[[2]]==unique){
      x <- append(x,-1)
    } else if ((i[[1]]==unique & i[[2]]!=unique) | (i[[1]]!=unique & i[[2]]==unique)){
      x <- append(x,0)
    } else if (i[[1]]!=unique & i[[2]]!=unique){
      x <- append(x,1)
    }
  }
  return(x)
}

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
    allele_pairs_list <- c(allele_pairs_list,allele_pairs)
    total_alleles_list <- c(total_alleles_list,list(total_alleles))
    unique_alleles_list <- c(unique_alleles_list,list(unique_alleles))
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
  mutate(k=n()) %>%                                        #add number of unique alleles per locus
  group_by(unique_alleles,locus) %>%
  mutate(freq=freq_function(unique_alleles,total_alleles), #add total allele frequencies 
         h=homo_freq_function(unique_alleles,allele_pairs), #add homozygote frequencies
         x=list(x_vector_function(unique_alleles,allele_pairs))) %>% #add x vector with allele info
  select(-total_alleles,-allele_pairs)
