## Checking and installing needed libraries:
#packages_requirements <- c("tidyverse", "vegan", "ggrepel", "BiocManager", "scales", "patchwork")
#install.packages(setdiff(packages_requirements, rownames(installed.packages())))

#library(BiocManager)
#BiocManager::install("phyloseq") #Installation of phyloseq by the BiocManager package

# Run all scripts ---------------------------------------------------------
source("R/01_load.R")
source("R/02_clean.R")
source("R/03_augment.R")
source("R/04_model_i.R")
source("R/05_model_ii.R")
source("R/06_model_iii.R")
source("R/07_model_iv.R")
source("R/08_model_v.R")