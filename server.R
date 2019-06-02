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

data <- read.csv("data/master.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   

  output$table <- renderDataTable({
    if(input$input_gender == "Both") {
      desired_df <-  data %>%
        filter(input$input_country == country,input$input_age == age,input$input_generation == generation) 
    } 
    desired_df <- data %>%
      filter(input$input_country == country,input$input_gender == sex,input$input_age == age,input$input_generation == generation) 
  })
  
  # Line graph for showing relationship
  # NEED TO UPDATE: ERROR MESSAGE FOR COUNTRIES AND YEARS THAT CANNOT SHOW
  output$lineg <- renderPlot({
    data_filter_df <- data %>% 
      filter(input$input_year == year, input$input_country == country, input$input_gender == sex)
    
    output <- barplot(data_filter_df$suicides_no, names.arg = as.character(sort(data_filter_df$age)))
    
  })
  
})
