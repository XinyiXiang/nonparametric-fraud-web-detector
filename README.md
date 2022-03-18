# Nonparametric Fraudulent Websites Detector
<!-- badges: start -->

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

<!-- badges: end -->

- [WriteUp]()
- [Slides]()


Paricipating Project in Winter 2022 University of Washington Directed Reading Program. This project’s primary goal is to demonstrate a data science project’s deployment into fraud precention using open source and free tools such as R, h2o, Caret, and others. That includes the following components:


# Dataset
Priliminary data used in this research for test and train set splitting, test statistics and other metrics calculation comes from the 


[UCI Phishing Website Dataset](https://archive.ics.uci.edu/ml/datasets/phishing+websites)
- ```old.arff```
- ```TrainingData.arff```
 
# Dashboard
An R Shiny dashboard that provides a set of tools descriptive and predictive analysis of predictors data. 

## XGBoost
XGBoost is a type of ensemble tree method that apply the principle of boosting weak learners, generally Classification And Regression Trees (CARTs), using the gradient descent architecture. However, it is with observable improvements upon the base Gradient Boosting Machines framework that XGBoost advances its system optimization and algorithmic enhancements.

### Variable Importance Heatmap
![alt text](https://github.com/XinyiXiang/nonparametric-fraud-web-detector/blob/146cd1b80c1ba7166b8612408cfa01c1d062c850/img/varImpHeatmap.png)


### Metrics in the Model

**Information Gain**


![Gain Equation](https://latex.codecogs.com/svg.image?\text{Gain}&space;=&space;\frac{1}{2}[\frac{G_L^2}{H_L&space;&plus;&space;\lambda}&space;&plus;&space;\frac{G_R^2}{H_R&space;&plus;&space;\lambda}&space;-&space;\frac{(G_L&space;&plus;&space;G_R)^2}{H_L&space;&plus;&space;H_R&space;&plus;&space;\lambda}]&space;-&space;\gamma)


Gain is a parameter that corresponds to the importance of the node in the model, for split nodes, the gain is the information gain metric of a split node.


**Cover**


The Cover metric is the contribution of each feature to the number of observations summed up from each tree expressed in percentage, it is calculated as the second order gradient of training data classified to the leaf.



## Random Forest
![alt text](https://github.com/XinyiXiang/nonparametric-fraud-web-detector/blob/146cd1b80c1ba7166b8612408cfa01c1d062c850/img/meanDecreaseGini.png)


```R
# Different levels causes an issue 
# stick with just training and break it into halves
old <- readARFF("../data/old.arff")
data <- readARFF("../data/TrainingDataset.arff")

# Split training into train and test set
ind <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
train <- data[ind==1,]
test <- data[ind==2,]

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
```

## Support Vector Machine
```R
### Use h2o built-in psvm implementation ###
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

### Use external libraries ###
install.packages('e1071')
library(e1071)
training$Result = factor(training$Result, levels = c(0, 1))

classifier <- svm(formula = Result ~.,
                 data = train,
                 type = 'C-classification',
                 kernel = 'linear')
plot(classifier,data=train,formula = Result ~.,)
perf <- h2o.performance(svm)
```


# Model Comparison and Error Analysis
### RF Model that Includes Every Predictor
| Accuracy               | 0.9811           |
|------------------------|------------------|
| 95\% CI                | (0.9778, 0.9841) |
| No Information Rate    | 0.5595           |
| P-Value [Acc $>$ NIR]  | $<2e-16$         |
| Kappa                  | 0.9617           |
| Mcnemar's Test P-Value | 0.09673          |
| Sensitivity            | 0.9755           |
| Specificity            | 0.9856           |
| Pos Pred Value         | 0.9816           |
| Neg Pred Value         | 0.9808           |
| Prevalence             | 0.4405           |
| Detection Rate         | 0.4297           |
| Detection Prevalence   | 0.4377           |
| Balanced Accuracy      | 0.9805           |
| 'Positive' Class       | -1               |


### RF Model that Includes the Prominent Five Predictors
| Accuracy               | 0.9246           |
|------------------------|------------------|
| 95\% CI                | (0.9152, 0.9333) |
| No Information Rate    | 0.551            |
| P-Value [Acc $>$ NIR]  | $< 2.2e-16$      |
| Kappa                  | 0.8482           |
| Mcnemar's Test P-Value | 0.0008826        |
| Sensitivity            | 0.9339           |
| Specificity            | 0.9171           |
| Pos Pred Value         | 0.9017           |
| Neg Pred Value         | 0.9445           |
| Prevalence             | 0.4490           |
| Detection Rate         | 0.4193           |
| Detection Prevalence   | 0.4650           |
| Balanced Accuracy      | 0.9255           |
| 'Positive' Class       | -1               |
