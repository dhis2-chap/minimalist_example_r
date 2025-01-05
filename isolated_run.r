source("train.r")
source("predict.r")

train_chap("input/trainData.csv", "output/model.bin")
predict_chap("output/model.bin", "input/trainData.csv", "input/futureClimateData.csv", "output/predictions.csv")
