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

for (i in 1:(length(header)-1)) {
  v1 <- ff1 %>% pull(i)
  v2 <- ff2 %>% pull(i)
  v3 <- as_tibble(c(v1, v2))
  tt=(v3 %>% group_by(value) %>% tally())
  print (tt)
}
print(sum(tt[2]))
