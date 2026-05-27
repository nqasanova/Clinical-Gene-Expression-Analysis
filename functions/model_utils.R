# Fit logistic model
fit_model <- function(data, features, outcome) {
  formula <- as.formula(
    paste(outcome, "~", paste(features, collapse = "+"))
  )
  
  glm(formula, data = data, family = "binomial")
}

# Evaluate model accuracy
evaluate_model <- function(model, data, outcome) {
  preds <- predict(model, data, type = "response")
  class <- ifelse(preds > 0.5, 1, 0)
  
  mean(class == data[[outcome]])
}