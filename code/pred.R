##############################################################
# Load packages and set preliminary directory
set.seed(499)
pkgs <- c("farff", "randomForest", "caret", "ggplot2")

for(pkg in pkgs){
  if(!(pkg %in% rownames(installed.packages()))){
    install.packages(pkg, dependencies = TRUE)
  }
  lapply(pkg, FUN = function(X){
    do.call("require", list(X))
  })
}

setwd("~/Documents/GitHub/STAT499/code")

# Different levels causes an issue 
# stick with just training and break it into halves
old <- readARFF("../data/old.arff")
data <- readARFF("../data/TrainingDataset.arff")

# Split training into train and test set
ind <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
train <- data[ind==1,]
test <- data[ind==2,]

#############################################
#Fit Models

# Use every predictor
rf1 <- randomForest(Result~.,data=train)

# Get a sense of the most important predictors
vip <- varImpPlot(rf1,
           sort = T,
           n.var = 10) + title("Var Importance in  ")

# Only the 5 most important predictors
rf2 <- randomForest(Result~SSLfinal_State
                    + URL_of_Anchor
                    + web_traffic
                    + having_Sub_Domain
                    + Prefix_Suffix,data=train)

#############################################
#Train Errors

#large model has 98% accuracy
train.error1 <- predict(rf1, train)
confusionMatrix(train.error1, train$Result)

#small model has 93% accuracy
train.error2 <- predict(rf2, train)
confusionMatrix(train.error2, train$Result)

#############################################
#Test Errors

#large model has 97% accuracy
test.error1 <- predict(rf1,test)
confusionMatrix(test.error1,test$Result)

#smaller model has 93% accuracy
test.error2 <- predict(rf2,test)
confusionMatrix(test.error2,test$Result)

##############################################################
# XGBoost ref: https://xgboost.readthedocs.io/en/stable/R-package/xgboostPresentation.html
install.packages("xgboost")
install.packages("DiagrammeR")
library(xgboost)
library(DiagrammeR)

# Work with binary classification
levels(train$Result) <- c("0","1")
dtrain <- xgb.DMatrix(data = data.matrix(train),
                      label=data.matrix(train$Result))
dtest <- xgb.DMatrix(data = data.matrix(test),
                     label=data.matrix(test$Result))
watchlist <- list(train=dtrain,
                  test=dtest)
bst1 <- xgb.train(data=dtrain,max.depth=2,eta=1,
                 nthread=2, nrounds=2, watchlist=watchlist, 
                 objective="binary:logistic",                 
                 eval_metric="error")
# Built-in analyses
xgb_tree <- xgb.plot.tree(model=bst1)
xgb_deepness <- xgb.plot.deepness(model=bst1, trees=1:3)
pred <- predict(bst1, data.matrix(test$data))
error <- mean(as.numeric(pred>0.5)!=data.matrix(test$label))

# XGB model prepared for dashboard plot 
xgboostModel <- h2o.xgboost(y = "Result",
                            training_frame = as.h2o(training),
                            booster = "dart",
                            normalize_type = "tree",
                            seed = 1234)

##############################################################
# Supervised Linear Model - SVM
install.packages("h2o")
library(h2o)
h2o.init()

svm <- h2o.psvm(
 gamma = 0.01,
 rank_ratio = 0.1,
 y = "Result",
 training_frame = as.h2o(train),
 disable_training_metrics = FALSE
)

perf <- h2o.performance(svm)

install.packages('e1071')
library(e1071)
training$Result = factor(training$Result, levels = c(0, 1))

classifier <- svm(formula = Result ~.,
                 data = train,
                 type = 'C-classification',
                 kernel = 'linear')
plot(classifier,data=train,formula = Result ~.,)
perf <- h2o.performance(svm)

