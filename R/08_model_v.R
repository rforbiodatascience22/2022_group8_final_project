# Reading originale data for NMDS analysis.
NMDS_oto_data <- read_tsv("data/otu.tsv")
NMDS_map <- read_tsv("data/map.tsv")

# Normalizes data (relative abundances) and wrangles data
NMDS_oto_normalized <- NMDS_oto_data %>%
  select(-"Consensus Lineage") %>%
  mutate_at(vars(-`#OTU ID`), funs(./sum(.)*100)) %>%  
  # . = all data points. 
  # => Mutate all data (except OTU ID) with funs() finding relative abundances
  gather(SampleID, abundance, `A01`:`A30`) %>%
  spread(key = `#OTU ID`,value = 'abundance') %>%
  right_join(NMDS_map %>% 
               select(SampleID)) %>%
  column_to_rownames("SampleID")

# Running the NMDS analysis from the vegan-library. With k=2 (two dimensions)
NMDS_analysis <- NMDS_oto_normalized %>%
  metaMDS(k=2, 
          distance = "bray",
          trymax = 100000,
          try =200)

# Extracting the NMDS values for the two dimensions 
NMDS_values <- NMDS_analysis[["points"]] %>%
  as_tibble(rownames = "SampleID") %>%
  left_join(NMDS_map)

# Plotting the NMDS values:
NMDS_plot <- ggplot(data = NMDS_values,
       aes(x = MDS1, 
           y = MDS2, 
           shape = factor(Antibiotic), 
           label = Name)) +
  geom_point(size=1.5, alpha= 0.5) 
  # geom_text_repel is a special geom, not included in the usual tidyverse packages
  # geom_text_repel adds a nice feature to the normal geom_text. 
  # Where it tries to find the position for he labels, so that the labels 
  # overlap as little as possible. 
  # geom_text_repel()

NMDS_plot


ggsave("results/NMDS_plot.png")


library("phyloseq"); packageVersion("phyloseq")
library("plyr"); packageVersion("plyr")

x<-ordinate(NMDS_oto_data, method = "NMDS", distance = "bray", trymax = 50)

phyloseq_average(NMDS_oto_data)

otu_mat <- NMDS_oto_data %>%
  tibble::column_to_rownames("#OTU ID") 

