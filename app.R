library(shiny)
library(tidyverse)
library(pROC)

# Load data (correct paths)
data <- read_csv("data/gene_expression_data.csv")
selected <- read_csv("report/selected_genes.csv")$selected_genes

# Build model
formula <- as.formula(
  paste("outcome ~", paste(selected, collapse = "+"))
)

model <- glm(formula, data = data, family = "binomial")

# Predictions
preds <- predict(model, data, type = "response")

# UI
ui <- fluidPage(
  
  titlePanel("Clinical Gene Expression Dashboard"),
  
  sidebarLayout(
    
    sidebarPanel(
      h4("Selected Genes"),
      tableOutput("genes_table"),
      
      br(),
      h4("Model Info"),
      verbatimTextOutput("model_info")
    ),
    
    mainPanel(
      tabsetPanel(
        
        tabPanel(
          "Prediction Distribution",
          plotOutput("pred_plot")
        ),
        
        tabPanel(
          "ROC Curve",
          plotOutput("roc_plot")
        )
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Table: selected genes
  output$genes_table <- renderTable({
    tibble(Selected_Genes = selected)
  })
  
  # Model info
  output$model_info <- renderText({
    paste("Number of selected genes:", length(selected))
  })
  
  # Prediction plot
  output$pred_plot <- renderPlot({
    tibble(preds = preds, outcome = data$outcome) |>
      ggplot(aes(x = preds, fill = factor(outcome))) +
      geom_histogram(alpha = 0.5, bins = 20, position = "identity") +
      labs(
        title = "Prediction Distribution",
        x = "Predicted Probability",
        fill = "Outcome"
      ) +
      theme_minimal()
  })
  
  # ROC plot
  output$roc_plot <- renderPlot({
    roc_obj <- roc(data$outcome, preds)
    plot(roc_obj, col = "blue", lwd = 2, main = "ROC Curve")
  })
}

# Run app
shinyApp(ui = ui, server = server)