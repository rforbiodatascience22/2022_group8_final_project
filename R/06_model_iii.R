library(scales)

violin_1_A_data <- read_tsv("data/cfu_clean.tsv", show_col_types = FALSE) %>%
  select(c(Donor, Community, Antibiotic, Replicate, cfu_ml)) %>%
  mutate(cfu_ml = na_if(cfu_ml, 0) ) %>%
  mutate(Antibiotic = recode(Antibiotic,
                             "R" = "Rifampicin",
                             "P" = "Polymyxin",
                             "-" = "No Treatment")) %>%
  drop_na()


violin_1_A <- ggplot(data = violin_1_A_data,
       mapping = aes(x = Antibiotic,
                     y = cfu_ml)) +
  geom_violin(mapping = aes(fill = Community), alpha = 0.5) +
  geom_point(mapping = aes(shape = factor(Donor),
                           group = interaction(Donor, Community)),
             colour = 'black',
             size = 2.5,
             position = position_dodge(width = 0.75)) +
  geom_point(mapping = aes(shape = factor(Donor),
                           colour = Community,
                           group = interaction(Donor, Community)),
             position = position_dodge(width = 0.75)) +
  scale_fill_manual(values = c("#56B4E9", "#E69F00")) +
  scale_colour_manual(values = c("#56B4E9", "#E69F00")) +
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
  labs(title = "Focal strain Abundance",
       subtitle = "Effect of community, donor and antibiotic.",
       shape = "Donor",
       x = "Treatment",
       y = "Abundance (CFU mL-1)")
  

violin_1_A
ggsave("results/violin_1_A.png")




