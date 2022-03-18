# Nonparametric Fraudulent Websites Detector
- [WriteUp]()
- [Slides]()


Paricipating Project in Winter 2022 University of Washington Directed Reading Program. This project’s primary goal is to demonstrate a data science project’s deployment into fraud precention using open source and free tools such as R, h2o, Caret, and others. That includes the following components:
 
# Dashboard
An R Shiny dashboard that provides a set of tools descriptive and predictive analysis of predictors data. 

## XGBoost
XGBoost is a type of ensemble tree method that apply the principle of boosting weak learners, generally Classification And Regression Trees (CARTs), using the gradient descent architecture. However, it is with observable improvements upon the base Gradient Boosting Machines framework that XGBoost advances its system optimization and algorithmic enhancements.
### Metrics in the Model
![Gain Equation](https://latex.codecogs.com/svg.image?\text{Gain}&space;=&space;\frac{1}{2}[\frac{G_L^2}{H_L&space;&plus;&space;\lambda}&space;&plus;&space;\frac{G_R^2}{H_R&space;&plus;&space;\lambda}&space;-&space;\frac{(G_L&space;&plus;&space;G_R)^2}{H_L&space;&plus;&space;H_R&space;&plus;&space;\lambda}]&space;-&space;\gamma)


### Variance Importance Heatmap


## Random Forest


## Support Vector Machine


# Dataset
Priliminary data used in this research for test and train set splitting, test statistics and other metrics calculation comes from the 


[UCI Phishing Website Dataset](https://archive.ics.uci.edu/ml/datasets/phishing+websites)
- ```old.arff```
- ```TrainingData.arff```


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
