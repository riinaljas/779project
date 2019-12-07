#
# This is a Shiny web application "Find Closest County". You can run the application by clicking
# the 'Run App' button above.
# Author: Riin Aljas
# contact : aljasriin@gmail.com


library(shiny)
library(shinytest)
library(tidyverse)
library(DT)
data <- readRDS("sampledata.RDS") %>% head(100) %>% select(1:104)
source("functions.R")



#myvar <- as.character(readline("Enter the county: "))




# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Find Closest County"),
    #Ask for user input
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            helpText("Order US counties based on the closest county to it  
                     based on eucledian distance."),
            selectInput("myvar", 
                        label = "Look for the county, by typing the county name",
                        choices = data$,
                        selected = NULL),
            
            
            
            
            
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            textOutput("selected_var"),
            htmlOutput("county_list")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
    
    
    
    output$selected_var <- renderText({ 
            paste("Other counties' in similarity to", input$myvar)
        })
    
    output$county_list <- DT::renderDataTable ({
        myvar <- input$myvar
        countylist <- as.data.frame(close(data[ ,myvar], value=0, tol=NULL)) %>% rename(!!myvar := 1)
        countylist <- countylist %>% left_join(data) %>% select(1:5) %>% rename(euclidean_distance = 1) 
        countylist
    })
    

}

# Run the application 
shinyApp(ui = ui, server = server)
