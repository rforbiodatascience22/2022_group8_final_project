# Final project for group 8 - 
The project focuses on the study: "Human-associated microbiota suppress invading bacteria even under disruption by antibiotics", which can be found [here](https://www.nature.com/articles/s41396-021-00929-7).

The project uses the same data as the study to make models and plots which mostly reproduces the same models and plots produced in the study. The data can be found  [here](https://datadryad.org/stash/dataset/doi:10.5061%2Fdryad.d51c5b02r). The data is saved in "_raw".

All code in the project represented in R scripts is written attempting only to use tidyverse.

### Dependencies/libraries used in project:
- Tidyverse
- Scales
- Vegan
- BiocManager
- Patchwork
- Phyloseq

### Description of R scripts used in project
#### 00_doit.R
00_doit.R is a small script which launches all R scripts for the project.

#### 01_load.R
01_load.R reads and loads the original data from the article which is located in the "_raw" folder.

#### 02_clean.R
02_clean.R tidies the previously load files. Furthermore, 01_clean.R minimizes the redundancy in data which is not used in further analysis.
The output from 01_clean.R is: 
- otu_df_clean
- map_df_clean
- cfu_df_clean

#### 03_augment.R
03_augment.R joins otu_df_clean and map_df_clean into a single file:
- otu_map_merged.tsv

#### 04_model_i.R
04_model_i.R creates a heatmap from the file otu_map_merged.tsv.
The heatmap consist of the OTU data grouped into different species for each donor.

#### 05_model_ii.R
05_model_ii.R takes the data from cfu_clean.tsv and creates a general plot containing 3 subplots. Subplot A is a bar plot showing the CFU per mL of the focal strain in different conditions (absence of antibiotic, presence of Polymixin, and presence of Rifampicin) from 3 different donors. Subplot B is a boxplot showing the 3 different donors’ mean CFU per mL of the focal strain in the same 3 conditions. Subplot C shows the means’ donor CFU per mL.

#### 06_model_iii.R
06_model_iii.R takes the data from cfu_clean.tsv and produces a violin plot showing the abundance (in CFU per mL) in 3 different conditions (absence of antibiotic, presence of Polymixin, and presence of Rifampicin), from 3 different donors and specifying community presence or absence.

#### 07_model_iv.R
07_model_iv.R calculates the abundance, the richness (with phyloseq package), and the Shannon Index from 4 different conditions (only inoculum, absence of antibiotic, presence of Polymixin, and presence of Rifampicin) from the otu.tsv data. It presents the data into a violin plot.

#### 08_model_v.R
It takes the data from otu.tsv and map.tsv, normalizes it to relative abundances, and wrangles data. It does the non-metric-dis-scale (NMDS) analysis with the vegan library and it plots the results in a scatter plot.

