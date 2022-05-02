cfu_df <- read_csv("_raw/cfu_counts.csv") %>%
  as_tibble
  
  
map_df_cols <- read_lines("_raw/mapfile.txt",n_max=1) %>%
  str_split("\\t",simplify = TRUE)

map_df <- read_lines("_raw/mapfile.txt",skip=1,skip_empty_rows = TRUE) %>%
  as_tibble_col(column_name = "lines") %>%
  separate(lines,map_df_cols,sep="\\t")

write_tsv(otu_df, file='data/map.tsv')  
  
otu_df_cols <- read_lines("_raw/otufile.txt",n_max=1) %>%
  str_split("\\t",simplify = TRUE)

otu_df <- read_lines("_raw/otufile.txt",skip=1,skip_empty_rows = TRUE) %>%
  as_tibble_col(column_name = "lines") %>%
  separate(lines,otu_df_cols,sep="\\t")


write_tsv(otu_df, file='data/otu.tsv')
