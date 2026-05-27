# Load libraries
library(tidyverse)
library(glmnet)

# Load data
data <- read_csv("data/gene_expression_data.csv")

# Prepare matrices
x <- data |> select(starts_with("gene_")) |> as.matrix()
y <- data$outcome

# Fit LASSO model
lasso_model <- cv.glmnet(x, y, family = "binomial", alpha = 1)

# Extract selected features
coef_lasso <- coef(lasso_model, s = "lambda.min")

selected_genes <- rownames(coef_lasso)[coef_lasso[,1] != 0]

# Save selected genes
write_csv(
  tibble(selected_genes),
  "report/selected_genes.csv"
)