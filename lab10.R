
# http://docs.h2o.ai/h2o-tutorials/latest-stable/tutorials/deeplearning/index.html?_ga=1.144792372.1899517290.1471722570
install.packages("h2o", type="source", 
                 repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turing/3/R")))

library(h2o)

# initialize h2o
h2o.removeAll()
h2o.init(nthreads=-1, max_mem_size="2G")

# iris
train.hex <- h2o.importFile("https://h2o-public-test-data.s3.amazonaws.com/smalldata/iris/iris_wheader.csv")
splits <- h2o.splitFrame(train.hex, 0.75, seed=1234)
dl <- h2o.deeplearning(x=1:3, y="petal_len",
                       training_frame=splits[[1]],
                       distribution="quantile", quantile_alpha=0.8)
h2o.predict(dl, splits[[2]])


# mnist
train <- h2o.importFile("https://h2o-public-test-data.s3.amazonaws.com/bigdata/laptop/mnist/train.csv.gz")
test <- h2o.importFile("https://h2o-public-test-data.s3.amazonaws.com/bigdata/laptop/mnist/test.csv.gz")

summary(train)
summary(test)

y <- "C785"
x <- setdiff(names(train), y)

train[,y] <- as.factor(train[,y])
test[,y] <- as.factor(test[,y])

# multi-layer, feedforward neural networks 
model <- h2o.deeplearning(
  x = x,
  y = y,
  training_frame = train,
  validation_frame = test,
  distribution = "multinomial",
  activation = "RectifierWithDropout",
  hidden = c(32,32,32),
  input_dropout_ratio = 0.2,
  balance_classes = T,
  sparse = TRUE,
  l1 = 1e-5,
  epochs = 10)

# with CV
model_cv <- h2o.deeplearning(
  x = x,
  y = y,
  training_frame = train,
  distribution = "multinomial",
  activation = "RectifierWithDropout",
  hidden = c(32,32,32),
  input_dropout_ratio = 0.2,
  balance_classes = T,
  sparse = TRUE,
  l1 = 1e-5,
  epochs = 10,
  nfolds = 5)

# View specified parameters of the deep learning model
model@parameters
# Examine the performance of the trained model model 
# display all performance metrics
h2o.performance(model) # training metrics 
h2o.performance(model, valid = TRUE) # validationmetrics
# Get MSE only
h2o.mse(model, valid = TRUE)
# Cross-validated MSE
h2o.mse(model_cv, xval = TRUE)

# Classify the test set (predict class labels)
# This also returns the probability for each class 
pred <- h2o.predict(model, newdata = test)
# Take a look at the predictions
head(pred)

# Train Deep Learning model and validate on test set
# and save the variable importances
model_vi <- h2o.deeplearning(
  x = x,
  y = y,
  training_frame = train,
  validation_frame = test,
  distribution = "multinomial",
  activation = "RectifierWithDropout",
  hidden = c(32,32,32),
  input_dropout_ratio = 0.2,
  balance_classes = T,
  sparse = TRUE,
  l1 = 1e-5,
  epochs = 10,
  variable_importances = TRUE)
# Retrieve the variable importance
h2o.varimp(model_vi)


model_path <- h2o.saveModel(object=model, path=getwd(), force = TRUE)
print(model_path)

saved_model <- h2o.loadModel(model_path)


# Previous sections discussed purely supervised Deep Learning tasks. 
# However, Deep Learning can also be used for unsupervised feature learning or, 
# more specifically, nonlinear dimensionality reduction (Hinton et al, 2006).

# Import ECG train and test data into the H2O cluster
train_ecg <- h2o.importFile(
  path = "http://h2o-public-test-data.s3.amazonaws.com/smalldata/anomaly/ecg_discord_train.csv",
  header = FALSE,
  sep = ",")
test_ecg <- h2o.importFile(
  path = "http://h2o-public-test-data.s3.amazonaws.com/smalldata/anomaly/ecg_discord_test.csv",
  header = FALSE,
  sep = ",")

# Train deep autoencoder learning model on "normal"
# training data, y ignored
anomaly_model <- h2o.deeplearning(
  x = names(train_ecg),
  training_frame = train_ecg,
  activation = "Tanh",
  autoencoder = TRUE,
  hidden = c(50,20,50),
  balance_classes = T,
  sparse = TRUE,
  l1 = 1e-4,
  epochs = 100)

# Compute reconstruction error with the Anomaly
# detection app (MSE between output and input layers)
recon_error <- h2o.anomaly(anomaly_model, test_ecg)
# Pull reconstruction error data into R and
# plot to find outliers (last 3 heartbeats)
recon_error <- as.data.frame(recon_error)
recon_error
plot.ts(recon_error)

# Note: Testing = Reconstructing the test dataset
test_recon <- h2o.predict(anomaly_model, test_ecg)
head(test_recon)


# another dataset
# https://github.com/h2oai/h2o-3/blob/master/h2o-r/demos/rdemo.airlines.delay.large.R

library(h2o)
h2o.init()

## Find and import data into H2O
pathToData   <- h2o:::.h2o.locate("bigdata/laptop/airlines_all.05p.csv")
print("Importing airlines dataset into H2O...")
raw <- h2o.importFile(path = pathToData, parse=FALSE)
setup <- h2o.parseSetup(raw)
setup$column_types[which(setup$column_names %in% "AirTime")]  <- "Numeric"
setup$column_types[which(setup$column_names %in% "AirDelay")] <- "Numeric"
airlines.hex <- h2o.parseRaw(raw, col.types=setup$column_types)

## Grab a summary of imported frame
summary(airlines.hex)

## Look at the distribution of flights per Year, per Month
h2o.hist(airlines.hex$Year)
h2o.hist(airlines.hex$Month)

## Create scatter plots by taking a random sample into R to plot and graphing linear fit
scatter_plot <- function(data, x, y, max_points = 1000, fit = T) {
  if (fit) {
    lr <- h2o.glm(x = x, y = y, training_frame = data, family = "gaussian")
    coeff <- lr@model$coefficients_table$coefficients
  }
  
  df <- data[,c(x, y)]
  
  runif <- h2o.runif(df)
  df.subset <- df[runif < max_points/nrow(data),]
  df.R <- as.data.frame(df.subset)
  h2o.rm(df.subset)
  if (fit) h2o.rm(lr@model_id)
  
  plot(x = df.R[,x], y = df.R[,y], col = "yellow", xlab = x, ylab = y)
  if (fit) abline(coef = coeff, col = "black")
}

scatter_plot(data = airlines.hex, x = "Distance", y = "AirTime", fit = T)
scatter_plot(data = airlines.hex, x = "UniqueCarrier", y = "ArrDelay", max_points = 5000, fit = F)

## Flight by Month calculated using H2O's fast groupby
print("Splitting data into groups of 12 month and aggregating on two columns...")
flightByMonth   <- h2o.group_by(data = airlines.hex, by = "Month", nrow("Month"), sum("Cancelled"))
flightByMonth.R <- as.data.frame(flightByMonth)

## Set Column Type for Enumerator or Factor Columns
airlines.hex$Year      <- as.factor(airlines.hex$Year)
airlines.hex$Month     <- as.factor(airlines.hex$Month)
airlines.hex$DayOfWeek <- as.factor(airlines.hex$DayOfWeek)
airlines.hex$Cancelled <- as.factor(airlines.hex$Cancelled)

## Parameter Creation
hour1 <- airlines.hex$CRSArrTime %/% 100
mins1 <- airlines.hex$CRSArrTime %% 100
arrTime <- hour1*60+mins1

hour2 <- airlines.hex$CRSDepTime %/% 100
mins2 <- airlines.hex$CRSDepTime %% 100
depTime <- hour2*60+mins2

travelTime <- ifelse(arrTime - depTime > 0, arrTime - depTime, NA)
airlines.hex$TravelTime <- travelTime
scatter_plot(airlines.hex, "Distance", "TravelTime")

## Imputation : You can also choose to impute missing values by taking the mean of subsets.
h2o.impute(data = airlines.hex, column = "Distance", by = c("Origin","Dest"))
scatter_plot(airlines.hex, "Distance", "TravelTime")

#####################################################################################################################

## Create test/train split
data.split <- h2o.splitFrame(data = airlines.hex, ratios = 0.8)
data.train <- data.split[[1]]
data.test <- data.split[[2]]

# Set predictor and response variables
myY <- "IsDepDelayed"
myX <- c("Origin", "Dest", "Year", "UniqueCarrier", "DayOfWeek", "Month", "Distance", "FlightNum")

## Build GLM
start    <- Sys.time()
data.glm <- h2o.glm(y = myY, x = myX, training_frame = data.train, validation_frame = data.test, family = "binomial",
                    standardize=T, model_id = "glm_model", alpha = 0.5, lambda = 1e-05)
glm_time <- Sys.time() - start
print(paste("Took", round(glm_time, digits = 2), units(glm_time), "to build logistic regression model."))

## Build GBM Model
start    <- Sys.time()
data.gbm <- h2o.gbm(y = myY, x = myX, balance_classes = T, training_frame = data.train, validation_frame = data.test,
                    ntrees = 100, max_depth = 5, model_id = "gbm_model", distribution = "bernoulli", learn_rate = .1,
                    min_rows = 2)
gbm_time <- Sys.time() - start
print(paste("Took", round(gbm_time, digits = 2), units(gbm_time), "to build a GBM model."))

## Build Random Forest Model
start    <- Sys.time()
data.drf <- h2o.randomForest(y = myY, x = myX, training_frame = data.train, validation_frame = data.test, ntrees = 150,
                             max_depth = 5, model_id = "drf_model", balance_classes = T)
drf_time <- Sys.time() - start
print(paste("Took", round(drf_time, digits = 2), units(drf_time), "to build a Random Forest model."))

## Build Deep Learning Model
start   <- Sys.time()
data.dl <- h2o.deeplearning(y = myY, x = myX, training_frame = data.train, validation_frame = data.test, hidden=c(10, 10),
                            epochs = 5, balance_classes = T, loss = "Automatic", variable_importances = T)
dl_time <- Sys.time() - start
print(paste("Took", round(dl_time, digits = 2), units(dl_time), "to build a Deep Learning model."))

## Variable Importance - For feature selection and rerunning a model build
print("GLM: Sorted Standardized Coefficient Magnitudes To Find Nonzero Coefficients")
data.glm@model$standardized_coefficient_magnitudes
print("GBM: Variable Importance")
data.gbm@model$variable_importances
print("Random Forest: Variable Importance")
data.drf@model$variable_importances
print("Deep Learning: Variable Importance")
data.dl@model$variable_importances












all <- read.table("/Users/weng/Desktop/combi/BSG_all/analysis/freqTbl.txt", sep="\t", header=T)
label <- read.table("/Users/weng/Desktop/combi/BSG_all/analysis/label.txt", sep="\t", header=F)
all$yLabel <- label[, 1]
all <- as.h2o(all)
y <- "yLabel"
x <- setdiff(names(all), y)
all[, y] <- as.factor(all[, y])
splits <- h2o.splitFrame(all, 0.9, seed=777)
dl <- h2o.deeplearning(x=x, y=y,
                       training_frame=all,
                       distribution = "AUTO",
                       activation = "RectifierWithDropout",
                       hidden = c(32,32,32),
                       input_dropout_ratio = 0.2,
                       balance_classes = TRUE,
                       sparse = TRUE,
                       l1 = 1e-5,
                       epochs = 10,
                       nfolds = 5)
dl@parameters
h2o.performance(dl) # training metrics 
h2o.performance(dl, valid = TRUE) # validationmetrics
# Get MSE only
pred <- h2o.predict(dl,  splits[[2]])
# Take a look at the predictions
head(pred)



