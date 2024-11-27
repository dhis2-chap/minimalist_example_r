# Define the predict function
##
predict_chap <- function(model_fn, historic_data_fn, future_climatedata_fn, predictions_fn) {
  # Read the future climate data
  df <- read.csv(future_climatedata_fn)

  # Extract features
  X <- df[, c("rainfall", "mean_temperature"), drop = FALSE]

  # Load the trained model
  model <- readRDS(model_fn)  # Assumes the model was saved using saveRDS

  # Make predictions
  #browser()
  y_pred <- predict(model, newdata = X)

  # Add predictions to the dataframe
  df$sample_0 <- y_pred

  # Save predictions to a CSV file
  write.csv(df, predictions_fn, row.names = FALSE)

  # Print predictions
  print(paste("Predict - forecast values:", paste(y_pred, collapse = ", ")))
}

# Main logic to handle command-line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 4) {
#  stop("Usage: Rscript predict.R <model_fn> <historic_data_fn> <future_climatedata_fn> <predictions_fn>")
  
  model_fn <- args[1]
  historic_data_fn <- args[2]
  future_climatedata_fn <- args[3]
  predictions_fn <- args[4]
  
  # Call the predict function with the arguments
  predict(model_fn, historic_data_fn, future_climatedata_fn, predictions_fn)
}