library('tidyverse')
data <- read_lines("/cloud/project/data/Lithobates pipiens/Lithobates pipiens_LP1-A.txt", skip = 1) 
ncols = match('pop', data)-1
loci_id=rev(data[1:(ncols+1)])


f <- read.delim("/cloud/project/data/Lithobates pipiens/Lithobates pipiens_LP1-A.txt", header=TRUE)
for (i in 1:nrow(f)){
  f[i,]=sub("," , "" , f[i,])
  f[i,]=str_squish(f[i,])
}
f <- f %>% 
  slice(n = ncols+2:nrow(f)) %>% 
  separate(colnames(f[1]),into= loci_id, sep=" ")


header <- loci_id


