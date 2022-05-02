cfu_df <- read_csv("data/cfu_counts.csv") %>%
  as_tibble
  
  
map_df_cols <- read_lines("data/mapfile.txt",n_max=1) %>%
  str_split("\\t")

map_df <- read_lines("data/mapfile.txt",skip=1,skip_empty_rows = TRUE) %>%
  as_tibble_col(column_name = "lines") %>%
  separate(lines,map_df_cols[[1]],sep="\\t")
  
  
  
otu_df_cols <- read_lines("data/otufile.txt",n_max=1) %>%
  str_split("\\t")

otu_df <- read_lines("data/otufile.txt",skip=1,skip_empty_rows = TRUE) %>%
  as_tibble_col(column_name = "lines") %>%
  separate(lines,otu_df_cols[[1]],sep="\\t")