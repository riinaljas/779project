#
# This is a Shiny web application "Find Closest County". You can run the application by clicking
# the 'Run App' button above.
# Author: Riin Aljas
# contact : aljasriin@gmail.com


library(shiny)
library(tidyverse)
library(DT)






all <- readRDS("sampledata.RDS")
populationincome <- readRDS("populationincome.RDS")
agepopulation <- readRDS("agepopulation.RDS")
ageincome <- readRDS("ageincome.RDS")


#source("functions.R")



vchoices <- 6:3225
names(vchoices) <- all$NAME

mylist <- as.data.frame(all$NAME)

mychoices <- c("population and income", "age and income", "age and population", "all")
ui = fluidPage(theme = "bootstrap.min.css",
               titlePanel("Find similar counties"),
               sidebarLayout(
                 sidebarPanel(
                   helpText("Order US counties based on the closest county to the county chosen,
                            based on eucledian distance."),
                   radioButtons("parameters", "Select parameters", choices = mychoices)
                   ),
                 
                 selectInput("columns","Select County",choices=vchoices)),
               mainPanel(
                 
                 dataTableOutput('mytable')
                 
                 
               ))

