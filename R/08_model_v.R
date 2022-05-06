NMDS_three <- read_tsv("data/otu.tsv")
NMDS_three_meta <- read_tsv("data/map.tsv")

otu_norm <- NMDS_three %>%
  select(-"Consensus Lineage") %>%
  mutate_at(vars(-`#OTU ID`), funs(./sum(.)*100)) %>% #normalize to relative abundance 
  gather(SampleID, abundance, `A01`:`A30`) %>%
  spread(key = `#OTU ID`,value = 'abundance') %>%
  right_join(NMDS_three_meta %>% 
               select(SampleID)) %>%
  column_to_rownames("SampleID")

NMDS_ord <- otu_norm %>%
  metaMDS(k=2)

NMDS_coords <- NMDS_ord[["points"]] %>%
  as_tibble(rownames = "SampleID") %>%
  left_join(NMDS_three_meta)


NMDS_plot <- ggplot(data = NMDS_coords,
       aes(x = MDS1, y = MDS2, shape = factor(Donor), label = Name)) +
  geom_point(size=1.5, alpha= 0.5) + 
  geom_text_repel()

ggsave("results/NMDS_plot.png")
