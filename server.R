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

# Data read and organized to be readable in good format
data <- read.csv("data/master.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)
# Define server 
shinyServer(function(input, output) {
   

  output$table <- renderDataTable({
    # Warning messages for user to see if no values selected
    validate(
      need(input$input_year, message = "Please select year."),
      need(input$input_country, message = "Please select country."),
      need(input$input_age, message = "Please select intended age group."),
      need(input$input_generation, message = "Please select generation. Can choose multiple values.")
    ) 
    
    # table organization
    if(input$input_gender == "Both") {
      desired_df <-  data %>%
        filter(input$input_country == country,input$input_age == age,input$input_generation == generation) 
    } 
    desired_df <- data %>%
      filter(input$input_country == country,input$input_gender == sex,input$input_age == age,input$input_generation == generation) 
    
  })
  
  # Bar graph for showing relationship between age group and number of suicide
  output$barg <- renderPlot({
    
    # the user selects both in the input gender widget then display bar graph with data containing both sexes
    if ( input$input_gender == "Both") {
      both_case <- data %>% filter(input$input_year == year, input$input_country == country)
      
      # Error message that there is no data available (data for graph is empty)
      validate(
        need(nrow(both_case) > 1, message = "Data not available / No recorded data available.")
      )
      
      # bar graph with ggplot 
      output <- ggplot(both_case, aes(both_case$age, both_case$suicides_no, fill = both_case$sex)) + geom_bar(stat="identity", position ="dodge") +
        scale_fill_brewer(palette = "Set1")
      output
      
    } else {
      ## the user selects either male or female in the gender selection widget
      data_filter_df <- data %>% 
        filter(input$input_year == year, input$input_country == country, input$input_gender == sex)
      
      # Error message to show if data not available
      validate(
        need(input$input_year, message = "Please select a year"),
        need(input$input_country, message = "Please choose a country."),
        need(nrow(data_filter_df) > 1, message = "Data not available/No recorded data available.")
      )
      
      # check if as.character is actually needed later
      output <- barplot(data_filter_df$suicides_no, names.arg = as.character(sort(data_filter_df$age)), main = "Number of Suicides in each Age Group",
                        xlab = "Age Groups", ylab = "Number of Suicides Recorded", col = "lightskyblue1", border = "lightskyblue1")
    }
    
  })
  
  # Text explanation for bar graph 
  output$bar_explanation <- renderText(
    explanation <- paste("The graph (if displayed) shows information about suicide numbers in each particular age group in the selected 
                         year that is chosen. A comparison of this allows us to be able to conclude which age group, in that country in the
                         particular year contains the highest suicide numbers.")
  )
  
  
  
})
