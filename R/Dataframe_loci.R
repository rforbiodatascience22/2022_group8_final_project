A1 <-function (string){
  A_1 <- (str_match(string, "^\\d{3}"))
  return(A_1)
}
A2 <-function (string){
  A_2 <- (substr(string,(str_length(string)/2)+1,(str_length(string))))
  return(A_2)
}




ff <- f %>% select(-pop)


fff1 <- mutate (ff, tet)

ff2 <- ff %>% mutate_all (A2)
ff1 <- ff %>% mutate_all (A1)




##### junk
df <- df %>% 
  mutate(func=tet(marker,f))


      
df <- header %>%
  as_tibble_col(column_name = 'marker') %>%
  filter(marker != 'pop')


vac <- ff %>% select(header)

vac <- vac %>% mutate('A_1'=substr(Rpi108,0,3), 'A_2'=substr(Rpi108,4,str_length(Rpi108)))

fff<-ff %>%
  tibble::rownames_to_column() %>%  
  pivot_longer(-rowname) %>% 
  pivot_wider(names_from=rowname, values_from=value)