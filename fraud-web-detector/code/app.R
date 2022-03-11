#---------------Loading the packages------------------------------------
set.seed(499)
setwd("~/Documents/GitHub/STAT499/fraud-web-detector/code")
# pkgs <- c("shiny", "shinydashboard","farff", "randomForest", "caret", "plotly", "shinycssloaders")
# 
# for(pkg in pkgs){
#   if(!(pkg %in% rownames(installed.packages()))){
#     install.packages(pkg, dependencies = TRUE)
#   }
#   lapply(pkg, FUN = function(X){
#     do.call("require", list(X))
#   })
# }
library(shiny)
library(shinydashboard)
library(farff)
library(randomForest)
library(caret)
library(plotly)
library(shinycssloaders)

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Phishing Detection",
                  dropdownMenu(
                    type = "notifications",
                    notificationItem(
                       text = "Phishing possibility exceeds 86%",
                       icon = icon("exclamation-triangle"),
                       status = "danger"
                     )
                  ),
                  
                  dropdownMenu(type = "tasks", badgeStatus = "warning",
                             taskItem(value = 17, color = "aqua",
                                      "Random Forest"),
                             taskItem(value = 65, color = "yellow",
                                      "XG Boost"),
                             taskItem(value = 89, color = "red",
                                      "SVM")
                             
                  )
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Random Forest", tabName = "rf", icon = icon("th")),
      menuItem("XG Boost", tabName = "xg", icon = icon("th")),
      menuItem("SVM", tabName = "svm", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "rf",
        fluidPage(
          fluidRow(
            infoBoxOutput("averageBox"),
            infoBoxOutput("approvalBox")
          ),
          box(width = 12, 
              title = "variable importance plot",
              withSpinner(plotOutput("var_imp_plot")
              )
          )
        )
      ),
      
      tabItem(tabName = "xg",
        h2("XG boost content")
      ),
      
      tabItem(tabName = "svm",
        h2("Support vector machine content")
      )
    )
  )
)

server <- function(input, output) {
  
  output$averageBox <- renderInfoBox({
    infoBox("Non-phishing Confirmed", "80%", 
            icon = icon("thumbs-up", 
                        lib = "glyphicon"),
            color = "yellow"
    )
  })
  
  output$approvalBox <- renderInfoBox({
    infoBox("Progress", 
            paste0(25 + input$count, "%"), 
            icon = icon("list"),
            color = "purple"
    )
  })
  
  # Variable importance plot
  output$var_imp_plot <- renderPlotly({
    # var_imp <- h2o.varimp(h2o_df$model)
    # var_imp <- var_imp[order(var_imp$scaled_importance),]
    # var_order <- var_imp$variable
    # var_imp$variable <- factor(var_imp$variable, levels = var_order)
    old <- readARFF("old.arff")
    training <- readARFF("TrainingDataset.arff")
    set.seed(122)
    ind <- sample(2, nrow(training), replace = TRUE, prob = c(0.7, 0.3))
    train <- training[ind==1,]
    test <- training[ind==2,]
    rf1 <- randomForest(Result~.,data=train)
    var_imp <- varImpPlot(rf1,
               sort = T,
               n.var = 10)
    
    plotOutput(varImpPlot(rf1,
                          sort = T,
                          n.var = 10)) 
  })
  } 


shinyApp(ui, server)
