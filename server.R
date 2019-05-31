#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(leaflet)

data <- read.csv("data/master.csv")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   

  output$table <- renderDataTable({
    if(input$input_gender == "Both") {
      desired_df <-  data %>%
        filter(input$input_country == country,input$input_age == age,input$input_generation == generation) 
    } else {
    desired_df <- data %>%
      filter(input$input_country == country,input$input_gender == sex,input$input_age == age,input$input_generation == generation) 
    }
  })
  
})
