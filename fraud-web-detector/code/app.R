library(shiny)
library(shinydashboard)

ui <- dashboardPage(skin = "purple",
  dashboardHeader(title = "Phishing Detection",
                  dropdownMenu(type = "notifications",
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
    
    fluidRow(
      infoBoxOutput("averageBox"),
      infoBoxOutput("approvalBox")
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
}

shinyApp(ui, server)