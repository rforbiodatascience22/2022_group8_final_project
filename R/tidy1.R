data <- read_lines("/cloud/project/data/Lithobates pipiens/Lithobates pipiens_LP1-A.txt", skip=1)

range<-length(data)
for (i in 1:range)
{
  if (data[i]=='pop'){
    loci_id=data[1:(i-1)]
  }
}
loci_id <- append(loci_id, "sample_id", after = 0)
str(loci_id)
tidytable

