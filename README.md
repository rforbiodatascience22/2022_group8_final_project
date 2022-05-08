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

### Description of R scripts used in project
#### 00_doit.R
00_doit.R is a small script. Which can luanch all R scripts for the project.
#### 01_load.R
01_load.R reads/loads the original data located in the folder: raw.
The data in the raw folder originates from [here](https://datadryad.org/stash/dataset/doi:10.5061%2Fdryad.d51c5b02r).

#### 02_clean.R
02_clean.R Is tidying the files from loaded in the previous r script. Futhermore, 01_clean.R minimizes the redundancy in data which is
not used in futher analysis.
The output files from 01_clean.R is: 
- otu_df_clean
- map_df_clean
- cfu_df_clean

#### 03_augment.R
The script simplies joins otu_df_clean and map_df_clean into a single file.
03_augment.R creates the file:
- otu_map_merged.tsv

#### 04_model_i.R
04_model_i.R creates a heatmap from the file otu_map_merged.tsv.
The heatmap consist of the OTU data gruoped into different species for each donor.

#### 05_model_ii.R
It takes the data from cfu_clean.tsv and creates a general plot containing 3 subplots. Subplot A is a bar plot showing the CFU per mL of the focal strain in different conditions (absence of antibiotic, presence of Polymixin, and presence of Rifampicin) from 3 different donors. Subplot B is a boxplot showing the 3 different donors’ mean CFU per mL of the focal strain in the same 3 conditions. Subplot C shows the means’ donor CFU per mL.

#### 06_model_iii.R
It takes the data from cfu_clean.tsv and produces a violin plot showing the abundance (in CFU per mL) in 3 different conditions (absence of antibiotic, presence of Polymixin, and presence of Rifampicin), from 3 different donors and specifying community presence or absence.

#### 07_model_iv.R
It calculates the abundance, the richness (with phyloseq package), and the Shannon Index from 4 different conditions (only inoculum, absence of antibiotic, presence of Polymixin, and presence of Rifampicin) from the otu.tsv data. It presents the data into a violin plot.


