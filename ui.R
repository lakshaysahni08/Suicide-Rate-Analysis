#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Suicide Rates In Various Countries"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("input_country","Country", choices = sort(data$country)),
      radioButtons("input_gender","Sex", choices = c("male" , "female", "Both")),
      selectInput("input_age","Age Group", choices = sort(data$age)),
       checkboxGroupInput("input_generation", "Generatios:",choices = unique(data$generation))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       dataTableOutput("table")
    )
  )
))
