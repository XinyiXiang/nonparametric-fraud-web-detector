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
library(ggplot2)

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
      menuItem("XG Boost", tabName = "xgb", icon = icon("th")),
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
              title = "Mean Decrease Gini vs. Variables in UCI Phishing Dataset",
              withSpinner(plotOutput("var_imp_plot")
              )
          )
        )
      ),
      
      tabItem(tabName = "xgb",
        fluidPage(
          box(
            width = 12,
            title = "XGB Model Variable Importance Heatmap Normalized Scores",
            withSpinner(plotOutput("xgb_var_imp_map"))
          )
        )
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
            paste0(25, "%"), 
            icon = icon("bars-progress", class=NULL, lib="font-awesome"),
            color = "purple"
    )
  })
  
  # Generate varImpPlot from pred.R
  source("pred.R", local=TRUE)
  
  # Variable importance plot
  output$var_imp_plot <- renderPlot({
    varImpPlot(rf1,
               sort = T,
               n.var = 10)
  })
  
  output$xgb_var_imp_map <- renderPlot({
    heatmap(xgboostModel)
  })
  
  output$svm_plot <- renderPlot({
    
  })
}





shinyApp(ui, server)
