#
# This is a Shiny web application "Find Closest County". You can run the application by clicking
# the 'Run App' button above.
# Author: Riin Aljas
# contact : aljasriin@gmail.com


library(shiny)
library(tidyverse)
library(DT)






mydata <- readRDS("sampledata.RDS")

source("functions.R")



vchoices <- 6:3225
names(vchoices) <- mydata$NAME

mylist <- as.data.frame(mydata$NAME)

mychoices <- c("population", "age", "median income", "all")
ui = fluidPage(theme = "bootstrap.min.css",
  titlePanel("Find similar counties"),
    sidebarLayout(
        sidebarPanel(
            helpText("Order US counties based on the closest county to the county chosen,
                     based on eucledian distance. For this test version, all three parameters 
have to be checked for the application to work properly. The smaller the distance, the closer the county. Table is searchable and sortable."),
            checkboxGroupInput("parameters", "Select parameters", choices = mychoices)
                        ),

            selectInput("columns","Select County",choices=vchoices)),
        mainPanel(

            dataTableOutput('mytable')


        ))


server = function(input, output) {
#    x <- reactive(input$parameter)
#    mydata <- reactive(if (x =="all") {
#      mydata=all
#    } else if (x == "population") {
#      mydata = population_and_income
#    } else {mydata == all}
# })


    observeEvent(
      input$columns, {
        cols <- as.numeric(input$columns)
        if(length(input$columns) == 1) {
  
            df <- data.frame(mydata[,cols])
            df <- bind_cols(df, mylist)  %>%
                           rename(County = `mydata$NAME`,
                       euc_dist = 1) 
           


            output$mytable = renderDataTable(
              df, options = list(
                order = list(list(1, 'asc'))))
       


        }else{
            output$mytable = renderDataTable(mydata[,cols])


        }


    })

}


shinyApp(ui = ui, server = server)

