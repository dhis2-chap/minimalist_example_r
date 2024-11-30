library(caret)  # For model training
library(readr)  # For reading CSV files
library(broom)  # For extracting model coefficients
library(tools)  # For file operations like saving the model

train_chap <- function(csv_fn, model_fn) {
  df <- read_csv(csv_fn)
  df$disease_cases[is.na(df$disease_cases)] <- 0
  model <- lm(disease_cases ~ rainfall + mean_temperature, data = df)
  saveRDS(model, file=model_fn)
}

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 2) {
  csv_fn <- args[1]
  model_fn <- args[2]

  train_chap(csv_fn, model_fn)
}# else {
#  stop("Usage: Rscript train.R <csv_fn> <model_fn>")
#}
