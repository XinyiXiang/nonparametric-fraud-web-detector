##############################################################
#randomForest library

library(farff) #Read .arff data
library(randomForest) #Random Forest function
library(caret) # Confusion Matrix function

setwd("~/Desktop/UW/DRP")

#different levels causes an issue here,
#stick with just training and break it into halves
old <- readARFF("old.arff")
training <- readARFF("TrainingDataset.arff")

#split training into train and test set
set.seed(122)
ind <- sample(2, nrow(training), replace = TRUE, prob = c(0.7, 0.3))
train <- training[ind==1,]
test <- training[ind==2,]

#https://www.r-bloggers.com/2021/04/random-forest-in-r/

#############################################
#Fit Models

#use every predictor
rf1 <- randomForest(Result~.,data=train)

#get a sense of the most important predictors
varImpPlot(rf1,
           sort = T,
           n.var = 10)

#only the 5 most important predictors
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
#xgboost library

#https://xgboost.readthedocs.io/en/stable/R-package/xgboostPresentation.html

library(xgboost)

#to work with binary classification
levels(train$Result) <- c("0","1")


dtrain <- xgb.DMatrix(data = data.matrix(train),
                      label=data.matrix(train$Result))
dtest <- xgb.DMatrix(data = data.matrix(test),
                     label=data.matrix(test$Result))

watchlist <- list(train=dtrain,
                  test=dtest)

#train error: 0
#test error: -0.44 (?)
bst <- xgb.train(data=dtrain,max.depth=1,eta=1,
                 nthread = 2, nrounds=1, watchlist=watchlist, 
                 objective = "binary:logistic",
                 eval_metric = "error")

