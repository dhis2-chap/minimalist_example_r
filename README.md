# Minimalist example of R model integration with CHAP 
This document demonstrates a minimalist example of how to write a CHAP-compatible forecasting model. The example is written in R, uses few variables without any lag and a standard machine learning model. It simply learns a linear regression from rain and temperature to disease cases in the same month, without considering any previous disease or climate data. It also assumes and works only with a single region. The model is not meant to accurately capture any interesting relations - the purpose is just to show how CHAP integration works in a simplest possible setting. Note that we include `options(warn=1)` at the top in both train.R and predict.R to see warnings and catch errors when running it through CHAP. This helps a lot with avoiding package depencies for more complex models.

## Running the model without CHAP integration
Before getting a new model to work as part of CHAP, it can be useful to develop and debug it while running it directly a small dataset from file. 

The example can be run in isolation (e.g. from the command line) using the file isolated_run.r:
```
RScript isolated_run.r  
```

This file only contains two code lines:  
* A call to a function "train", which trains a model from an input file "trainData.csv" and stores the trained model in a file "model.bin":
```R
train_chap("input/trainData.csv", "output/model.bin")
```

* A call to a function "predict" uses the stored model to forecast future disease cases (to a file "predictions.csv") based on input data on future climate predictions (from a file futureClimateData.csv):
```R
predict_chap("output/model.bin", "input/trainData.csv", "input/futureClimateData.csv", "output/predictions.csv")
```


### Training data
The example uses a minimalist input data containing rainfall, temperature and disease cases for a single region and two time points ("traindata.csv"):
```csv
time_period,rainfall,mean_temperature,disease_cases,location
2023-05,10,30,200,loc1
2023-06,2,30,100,loc1
2023-06,1,35,100,loc1
```

### Training the model
The file "train.r" contains the code to train a model. It reads in training data from a csv file to a data frame. It learns a linear regression from rainfall and mean_temperature (X) to disease_cases (Y). The trained model is stored to file using saveRDS:
```
train_chap <- function(csv_fn, model_fn) {
  df <- read.csv(csv_fn)
  df$disease_cases[is.na(df$disease_cases)] <- 0
  model <- lm(disease_cases ~ rainfall + mean_temperature, data = df)
  saveRDS(model, file=model_fn)
}

```
### Future climate data
A minimalist future (predicted) climate data is provided in a file "futureClimateData.csv". This file contains climate data for what is considered to be future periods (weather forecasts). It naturally contains no disease data):  
```
time_period,rainfall,mean_temperature,location
2023-07,20,20,loc1
2023-08,30,20,loc1
2023-09,30,30,loc1
```

### Generating forecasts
The file "predict.py" contains the code to forecast disease cases ahead in time based on future climate data (weather forecasts) and a previously trained model read from file. The disease forecasts are stored as a column in a csv file predictions_fn:
```
predict_chap <- function(model_fn, historic_data_fn, future_climatedata_fn, predictions_fn) {
  df <- read.csv(future_climatedata_fn)
  X <- df[, c("rainfall", "mean_temperature"), drop = FALSE]
  model <- readRDS(model_fn)  # Assumes the model was saved using saveRDS

  y_pred <- predict(model, newdata = X)
  df$sample_0 <- y_pred
  write.csv(df, predictions_fn, row.names = FALSE)

  print(paste("Forecasted values:", paste(y_pred, collapse = ", ")))
}

```

## Running the minimalist model as part of CHAP
To run the minimalist model in CHAP, we first define the model interface in an MLFlow-based yaml specification (in the file "MLproject", which defines :

```yaml
name: minimalist_r

docker_env:
  image: ivargr/r_inla:latest

entry_points:
  train:
    parameters:
      train_data: path
      model: str
    command: "Rscript train.r {train_data} {model}"
  predict:
    parameters:
      historic_data: path
      future_data: path
      model: str
      out_file: path
    command: "Rscript predict.r {model} {historic_data} {future_data} {out_file}"
```
The commands then calls the Rscripts train.r and predict.r and the code under the definition of the train and predict functions ensures they are called and with the correct arguments. If these parts are missing the code will fail when run through CHAP, but could still work locally through isolated run.
CHAP relies on Docker to run models defined in non-python programming languages (i.e. R), you thus need Docker installed to run your model successfully through CHAP. Please see the chap-core documentation for help in succeeding with this.  
After you have installed chap-core (see here for installation instructions: https://github.com/dhis2-chap/chap-core), it should be possible to run the minimalist model through CHAP as follows (remember to replace '/path/to/your/model/directory' with your local path):
```
chap evaluate --model-name /path/to/your/model/directory --dataset-name ISIMIP_dengue_harmonized --dataset-country brazil --report-filename report.pdf
```
