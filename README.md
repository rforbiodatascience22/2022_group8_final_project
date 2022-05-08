# Final project for group 8 - 
The project focuses on the study: "Human-associated microbiota suppress invading bacteria even under disruption by antibiotics". 
Which can be found [here](https://www.nature.com/articles/s41396-021-00929-7).

The project uses the same data as the study. 
To make models and plots which mostly reproduces the same models and plots produced in the study.

All code in the project represented in r scripts is written attempting only to use tidyverse.

### Dependencies/libraries used in project:
- Tidyverse
- scales
- vegan
- BiocManager
- patchwork
- phyloseq

### Description of r scripts used in project
#### 00_doit.r 
00_doit.r is a small script. Which can luanch all r scripts for the project.
#### 01_load.r
01_load.r reads/loads the original data located in the folder: raw.
The data in the raw folder originates from [here](https://datadryad.org/stash/dataset/doi:10.5061%2Fdryad.d51c5b02r).

#### 02_clean.r
02_clean.r Is tidying the files from loaded in the previous r script. Futhermore, 01_clean.r minimizes the redundancy in data which is
not used in futher analysis.
The output files from 01_clean.r is: 
- otu_df_clean
- map_df_clean
- cfu_df_clean

#### 03_augment.r
The script simplies joins otu_df_clean and map_df_clean into a single file 
03_augment.r creates the file:
- otu_map_merged.tsv

#### 04_model_i.r
04_model_i.r creates a heatmap from the file otu_map_merged.tsv.
The heatmap consist of the OTU data gruoped into different species for each donor.

