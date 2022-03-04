library(shiny)
library(shinydashboard)

ui <- dashboardPage(skin = "purple",
  dashboardHeader(title = "Phishing Detection",
                  dropdownMenu(type = "notifications",
                               notificationItem(
                                 text = "Phishing possibility exceeds 86%",
                                 icon = icon("exclamation-triangle"),
                                 status = "warning"
                               )
                  ),
                  
                  dropdownMenu(type = "tasks", badgeStatus = "success",
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
    
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(plotOutput("plot", height = 250)),
      
      box(
        title = "Controls",
        sliderInput("slider", "Number of observations:", 1, 100, 50)
      )
    )
    
    
  )
)

server <- function(input, output) {
  histdata <- rnorm(500)
  
  output$plot <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)