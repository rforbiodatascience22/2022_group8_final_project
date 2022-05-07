# Checking and installing needed libraries:
packages <- c("tidyverse", "vegan", "ggrepel")
install.packages(setdiff(packages, rownames(installed.packages()))) 

# Loading libraries 
library(tidyverse)
library(vegan)
library(ggrepel)
BiocManager::install("phyloseq")

## CFU counts file 

# Read file (csv) as a tibble
cfu_df <- read_csv("_raw/cfu_counts.csv", show_col_types = FALSE)
# Write a tsv file
write_tsv(cfu_df, file='data/cfu.tsv')

## Mapfile

# Read first line of mapfile to extract the column names as a character vector
map_df_cols <- read_lines("_raw/mapfile.txt",n_max=1) %>%
  str_split("\\t",simplify = TRUE)
# Read the rest of the lines (skip both first and empty ones)
map_df <- read_lines("_raw/mapfile.txt",skip=1,skip_empty_rows = TRUE) %>%
  as_tibble_col(column_name = "lines") %>%
  separate(lines,map_df_cols,sep="\\t")
# Write a tsv file
write_tsv(map_df, file='data/map.tsv')  
 

## OTU file

# Read first line of otufile to extract the column names as a character vector
otu_df_cols <- read_lines("_raw/otufile.txt",n_max=1) %>%
  str_split("\\t",simplify = TRUE)
# Read the rest of the lines (skip both first and empty ones)
otu_df <- read_lines("_raw/otufile.txt",skip=1,skip_empty_rows = TRUE) %>%
  as_tibble_col(column_name = "lines") %>%
  separate(lines,otu_df_cols,sep="\\t")
# Write a tsv file
write_tsv(otu_df, file='data/otu.tsv')

