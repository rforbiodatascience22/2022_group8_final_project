# Reading data
NMDS_otu_data <- read_tsv("data/otu_clean.tsv", show_col_types = FALSE)
NMDS_map <- read_tsv("data/map_clean.tsv", show_col_types = FALSE)

# Normalize data to (relative abundances) and wrangle data
NMDS_otu_normalized <- NMDS_oto_data %>%
  select(OTU, matches("A\\d{2}")) %>%
  mutate_at(vars(-OTU), funs(./sum(.)*100)) %>%  
  # . = all data points
  # => Mutate all data (except OTU ID) with funs() finding relative abundances
  gather(SampleID, abundance, `A01`:`A30`) %>%
  spread(key = OTU, value = 'abundance') %>%
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
  mutate(Treatment = case_when(Treatment=="None" ~ "AB free",
                               TRUE ~ Treatment),
         Treatment = fct_relevel(Treatment,
                                 "Inoculum",
                                 "AB free",
                                 "Polymyxin",
                                 "Rifampicin"))
  
# Plotting the NMDS values:
NMDS_plot <- ggplot(data = NMDS_values,
       aes(x = MDS1, 
           y = MDS2, 
           shape = factor(Donor),
           color = Treatment)) +
  geom_point(colour = 'black', alpha = 1, size = 2.8) +
  geom_point(alpha = 1, size = 2.1) +
  labs(shape = "Donor") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA))

# Saving plot
ggsave("results/NMDS_plot.png", width = 15, height = 10, units = "cm")
