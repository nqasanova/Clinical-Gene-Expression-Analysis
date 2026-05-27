# Load libraries
library(tidyverse)

# Load data
data <- read_csv("data/gene_expression_data.csv")

# Select gene columns
gene_data <- data |> select(starts_with("gene_"))

# Run PCA
pca <- prcomp(gene_data, scale. = TRUE)

# Extract first components
pca_scores <- as_tibble(pca$x[, 1:2])

# Combine with clinical info
pca_data <- bind_cols(data |> select(outcome, treatment), pca_scores)

# Plot PCA
pca_plot <- ggplot(pca_data, aes(PC1, PC2, color = treatment)) +
  geom_point() +
  theme_minimal() +
  labs(title = "PCA of Gene Expression Data")

ggsave("report/pca_plot.jpeg", pca_plot)