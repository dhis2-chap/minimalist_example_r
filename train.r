#library(argparse)
library(caret)  # For model training
library(readr)  # For reading CSV files
library(broom)  # For extracting model coefficients
library(tools)  # For file operations like saving the model
##
train_chap <- function(csv_fn, model_fn) {
  # Read the data
  df <- read_csv(csv_fn)

  # Print all column names (if desired)
  print(names(df))

  # Define features and response variable
  features <- c('rainfall', 'mean_temperature')
  #X <- df[, features, drop = FALSE]
  #Y <- df$disease_cases

  # Handle NA values in Y
  df$disease_cases[is.na(df$disease_cases)] <- 0
  #browser()
  # Train the linear regression model
  model <- lm(disease_cases ~ rainfall + mean_temperature, data = df)

  # Save the model
  saveRDS(model, file=model_fn)

  # Print the coefficients
  #coef_df <- tidy(model)
  #print(paste("Train - model coefficients:", paste(coef_df$term, coef_df$estimate, sep = "=", collapse = ", ")))
}


args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 2) {
#  stop("Usage: Rscript train.R <csv_fn> <model_fn>")

  csv_fn <- args[1]
  model_fn <- args[2]

  train(csv_fn, model_fn)
}
