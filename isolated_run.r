source("train.r")
source("predict.r")

train("input/trainData.csv", "output/model.bin")
predict("output/model.bin", "input/trainData.csv", "input/futureClimateData.csv", "output/predictions.csv")