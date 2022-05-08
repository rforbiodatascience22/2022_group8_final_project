library(tidyverse)

## CFU counts file 

# Read file (csv) as a tibble
cfu_df <- read_csv("_raw/cfu_counts.csv", show_col_types = FALSE)
# Write as tsv file in data folder
write_tsv(cfu_df, file='data/cfu.tsv')


## Mapping file

# Read tab-separated text file
map_df <- read_tsv("_raw/mapfile.txt", show_col_types = FALSE)
# Write a tsv file in data folder
write_tsv(map_df, file='data/map.tsv')  
 

## OTU counts file

# Read tab-separated text file as tibble
otu_df <- read_tsv("_raw/otufile.txt", show_col_types = FALSE)
# Write as tsv file in data folder
write_tsv(otu_df, file='data/otu.tsv')

