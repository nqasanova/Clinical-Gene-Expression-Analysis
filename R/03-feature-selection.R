# Load libraries
library(tidyverse)
library(glmnet)

# Load data
data <- read_csv("data/gene_expression_data.csv")

# Prepare matrix for LASSO
x <- data |>
  select(starts_with("gene_")) |>   # select gene variables
  as.matrix()

y <- data$outcome                   # binary outcome

# Fit LASSO model
lasso_model <- cv.glmnet(
  x,
  y,
  family = "binomial",
  alpha = 1
)

# Extract coefficients
coef_lasso <- coef(lasso_model, s = "lambda.min")

# Select important genes (REMOVE intercept!)
selected_genes <- rownames(coef_lasso)[coef_lasso[, 1] != 0] |>
  setdiff("(Intercept)")

# Save selected genes
write_csv(
  tibble(selected_genes),
  "report/selected_genes.csv"
)