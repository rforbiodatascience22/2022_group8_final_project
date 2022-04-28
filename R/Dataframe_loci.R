A1 <-function (string){
  A_1 <- (substr(string,0,(str_length(string)/2)))
  return(A_1)
}
A2 <-function (string){
  A_2 <- (substr(string,(str_length(string)/2)+1,(str_length(string))))
  return(A_2)
}

name1 <-function (name){
  new_name <- paste(name,'A1')
  return(new_name)
}
name2 <-function (name){
  new_name <- paste(name, 'A2')
  return(new_name)
}


ff <- f %>% select(-pop)

ff1 <- ff %>% mutate_all (A1)
ff2 <- ff %>% mutate_all (A2)

#ff1 <- rename_with(ff1, name1)
#ff2 <- rename_with(ff2, name2)

v1 <- ff1 %>% pull(1)
v2 <- ff2 %>% pull(1)
v3 <- as_tibble(c(v1, v2))
tt = (v3 %>% group_by(value) %>% tally())
total_allele <- (sum(rowSums(tt[,c(2)])))
tidy <- as_tibble(tt)
tidy <- tidy %>% mutate (Indiv =loci_id[2] )




for (i in 2:(length(loci_id)-1)) {
  v1 <- ff1 %>% pull(i)
  v2 <- ff2 %>% pull(i)
  v3 <- as_tibble(c(v1, v2))
  tt = (v3 %>% group_by(value) %>% tally())
  total_allele <- (sum(rowSums(tt[,c(2)])))
  #print(loci_id[i+1])
  #print(tt)


  tidy<-tidy %>% t %>% as.data.frame
  tt <- tt %>% add_column (Indiv =loci_id[i+1] )
  tt<-tt %>% t %>% as.data.frame
  tidy<-tidy %>% add_column(tt)
  
  tidy<-tidy %>% t %>% as.data.frame
}

tidy <- tidy %>% mutate (total_Al = total_allele)

tidy <- as_tibble(tidy)

n1 <- tidy %>% 
  select(n) %>%
  pull(1) %>%
  as.integer()

tidy <- tidy %>% 
  mutate (n =n1 )

tidy <- tidy %>% 
  mutate (freq = n/total_Al)


comparsion<-(ff1==ff2)

homo <-function (string){
  A_1 <- nest(ff1,ff2) 
  return(A_1)
}

print(ff1[1,1])
print(map(ff1))


