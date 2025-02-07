options(warn=1)

predict_chap <- function(model_fn, historic_data_fn, future_climatedata_fn, predictions_fn) {
  df <- read.csv(future_climatedata_fn)
  X <- df[, c("rainfall", "mean_temperature"), drop = FALSE]
  model <- readRDS(model_fn)  # Assumes the model was saved using saveRDS

  y_pred <- predict(model, newdata = X)
  df$sample_0 <- y_pred
  write.csv(df, predictions_fn, row.names = FALSE)

  print(paste("Forecasted values:", paste(y_pred, collapse = ", ")))
}

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 4) {
  model_fn <- args[1]
  historic_data_fn <- args[2]
  future_climatedata_fn <- args[3]
  predictions_fn <- args[4]
  
  predict_chap(model_fn, historic_data_fn, future_climatedata_fn, predictions_fn)
}# else {
#  stop("Usage: Rscript predict.R <model_fn> <historic_data_fn> <future_climatedata_fn> <predictions_fn>")
#}