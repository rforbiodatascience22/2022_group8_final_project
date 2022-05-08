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
  left_join(NMDS_map) %>%
  mutate(treatment = case_when(Name %in% c("Rifampicin 1", "Rifampicin 2", "Rifampicin 3") ~ "Rifampicin",
                               Name %in% c("Polymyxin 1","Polymyxin 2","Polymyxin 3") ~"Polymyxin",
                               Name %in% c("None 1", "None 2", "None 3") ~ "AB free",
                               Name %in% c("Inoculum") ~ "Inoculum"))

# Plotting the NMDS values:
NMDS_plot <- ggplot(data = NMDS_values,
       aes(x = MDS1, 
           y = MDS2, 
           shape = factor(Donor),
           color = treatment)) +
  geom_point(size=1.25, alpha= 0.5) 

NMDS_plot


ggsave("results/NMDS_plot.png")
