cfu <- read_tsv("data/cfu_clean.tsv") %>%
  #filter (Community == "+") %>%
  select(c(Donor, Community, Antibiotic, Replicate, cfu_ml)) %>%
  mutate(cfu_nl = cfu_ml*1e-6)

ggplot(data = cfu,
       mapping = aes(x = Antibiotic,
                     y = cfu_nl)) +
  geom_violin(mapping = aes(fill = Antibiotic)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = Donor),
             position = position_dodge(width = 0.4)) +
  labs(y = "Cells / nL")
             
             
library("vegan")

NMDS_ord <- otu_df_clean %>%
  select(-family) %>%
  filter(!row_number() %in% 
           c(37,42,45)) %>%
  metaMDS(k=2)

row <- otu_df_clean %>%
  select(family) %>%
  filter(!row_number() %in% 
           c(37,42,45)) %>%
  as_tibble()

NMDS_coords <- NMDS_ord[["points"]] %>%
  as_tibble() %>%
  mutate(row)


ggplot(data = NMDS_coords,
       aes(x = MDS1, y = MDS2)) +
  geom_point(size=2, alpha=0.8, aes(label=family))





