# Load libraries
library(tidyverse)

# Load functions
source("functions/model_utils.R")

# Load data
data <- read_csv("data/gene_expression_data.csv")

# Load selected genes
selected <- read_csv("report/selected_genes.csv")$selected_genes

if (length(selected) == 0) {
  stop("No genes selected by LASSO")
}

# Fit model
model <- fit_model(data, selected, "outcome")

# Evaluate model
accuracy <- evaluate_model(model, data, "outcome")

# Print results
print(paste("Model accuracy:", round(accuracy, 3)))

# Get predicted probabilities
preds <- predict(model, data, type = "response")

# Plot prediction distribution
tibble(preds = preds, outcome = data$outcome) |>
  ggplot(aes(x = preds, fill = factor(outcome))) +
  geom_histogram(alpha = 0.6, position = "identity") +
  labs(title = "Prediction Distribution", fill = "Outcome")

library(pROC)

# Compute ROC curve
roc_obj <- roc(data$outcome, preds)

# Plot ROC curve
plot(roc_obj, col = "blue", main = "ROC Curve")

# AUC value
auc_value <- auc(roc_obj)
print(paste("AUC:", round(auc_value, 3)))

write_csv(
  tibble(
    metric = c("accuracy", "auc"),
    value = c(accuracy, as.numeric(auc_value))
  ),
  "report/model_performance.csv"
)

ggsave("report/prediction_distribution.png")