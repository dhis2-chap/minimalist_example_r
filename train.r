#Define function train
train <- function(csv_fn, model_fn) {

}


args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 2) {
#  stop("Usage: Rscript train.R <csv_fn> <model_fn>")

  csv_fn <- args[1]
  model_fn <- args[2]

  train(csv_fn, model_fn)
}
