# Load libraries
library(tidyverse)

# Set seed
set.seed(123)

# Define dimensions
n_patients <- 150
n_genes <- 500

# Simulate gene expression matrix
gene_matrix <- matrix(
  rnorm(n_patients * n_genes),
  nrow = n_patients,
  ncol = n_genes
)

# Convert to tibble
gene_data <- as_tibble(gene_matrix)
colnames(gene_data) <- paste0("gene_", 1:n_genes)

# Simulate clinical variables
clinical_data <- tibble(
  patient_id = 1:n_patients,
  age = rnorm(n_patients, 60, 10),
  treatment = sample(c("A", "B"), n_patients, TRUE),
  outcome = rbinom(n_patients, 1, 0.5)
)

# Combine data
full_data <- bind_cols(clinical_data, gene_data)

# Save dataset
write_csv(full_data, "data/gene_expression_data.csv")

# Preview
glimpse(full_data)