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
library(plotly)
library(stringr)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    theme = shinytheme("cerulean"),
    # Application title
    titlePanel("Suicide Rates In Various Countries"),
    
    # Sidebar with a slider input for number of bins 
    navbarPage("Menu",
    
                 tabPanel("Home", 
              
                                    img(src = "https://edenvaleinn.com/wp-content/uploads/2018/10/folsom-train-ride-1500x609.jpg")
                         
                        ),
      navbarMenu("Information",  
        
        tabPanel("Table",
          sidebarLayout(
            sidebarPanel(
              selectInput("input_year", "Year", choices = sort(data$year)),
              selectInput("input_country","Country", choices = sort(data$country)),
              radioButtons("input_gender","Sex", choices = c("male" , "female", "Both")),
              selectInput("input_age","Age Group", choices = sort(data$age))
            ), mainPanel(
              dataTableOutput("table")
            )
    
              )
            ),
        tabPanel("Visualization",
                 sidebarLayout(
                   sidebarPanel(selectInput("vis_year", "Year", choices = as.integer(sort(data$year))),
                                selectInput("vis_country","Country", choices = sort(data$country)),
                                radioButtons("vis_gender","Sex", choices = c("male" , "female", "Both"))),
                   mainPanel(
                                  plotOutput("barg"),
                                  textOutput("bar_explanation")
                  )
                 )
                 ),
        tabPanel("Line Graph Visual", 
                 sidebarLayout(
                   sidebarPanel(
                     selectInput("country_for_range", "Country", choices = sort(data$country)),
                     sliderInput("input_range", "Year Range to be Displayed", 
                                 min = 1985, max = 2016, value = c(1996, 2005))),
                     mainPanel(
                       plotOutput("lineg")
                   )
               )
               
      )
        ),tabPanel("Analysis",
                   sidebarLayout(
                     sidebarPanel(
                       selectInput("country_for_analysis", "Country", choices = sort(data$country), selected = "Albania"),
                       sliderInput("input_range_analysis", "Year Range to be Displayed", 
                                   min = 1985, max = 2016, value = c(1996, 2005))
                     ), mainPanel(
                       textOutput("analysis"),
                       splitLayout(cellWidths = c("50%","50%"), plotOutput("analysis_gdp"), plotOutput("analysis_suicides")),
                       selectInput("analysis_for_year", "Select One Specific Year", choices = sort(data$year)),
                       selectInput("analysis_for_sex", "Select Sex", choices = unique(data$sex)),
                       #splitLayout(cellWidths = c("50%","50%"), selectInput("analysis_for_year"),selectInput("analysis_for_sex")),
                       plotlyOutput("pie_analysis")
                     )
                   )
                   
                   )
    
     )
   )
  )  

