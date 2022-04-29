harmonic_mean <- function(x,w){
  harm_df <- tibble(x=x,w=w) %>%
    mutate(w_x=w/x)
  sum_w <- harm_df %>%
    summarise(sum=sum(w)) %>%
    pull(sum)
  sum_w_x <- harm_df %>%
    summarise(sum=sum(w_x)) %>%
    pull(sum)
  harm_mean <- sum_w/sum_w_x
  return(harm_mean)
}

r <- df_combi_tidy %>%
  ungroup %>%
  summarise(r=weighted.mean(r_ij,w_ij)) %>%
  pull(r)

S <- df_combi_tidy %>%
  ungroup %>%
  summarise(S=harmonic_mean(S_ij,n_ij)) %>%
  pull(S)

if (S<30){
  r_ <- r-(0.0018+0.907/S+4.44/S**2)
  Ne <- (0.308+sqrt((0.3082)-2.08*r_))/(2*r_)
} else{
  r_ <- r-(1/S+3.19/S**2)
  Ne <- (1/3+sqrt((1/9)-2.76*r_))/(2*r_)
}

Ne
