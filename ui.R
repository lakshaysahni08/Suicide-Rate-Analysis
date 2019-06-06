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

data <- read.csv("data/master.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    theme = shinytheme("cerulean"),
    # Application title
    # Sidebar with a slider input for number of bins 
    navbarPage("Suicide Rates in Various Countries",
    
                 tabPanel("Home", 
                    textOutput("introduction_title"),
                    textOutput("introduction"), 
                    HTML('<center><img src="http://www.unityofwaco.org/sites/unityofwaco.org/files/styles/slider/public/DiscoverUnity1_rotor.jpg?itok=G4V2AtHB" width="800"></center>'),
                    tags$head(tags$style("#introduction_title{ color:#00BFFF; font-size: 20px; text-align: center;}
                                          #introduction{text-align: justify;font-size: 15px;}"))
                 ),
      navbarMenu("Information",  
        
        tabPanel("Table",
          sidebarLayout(
            sidebarPanel(
              sliderInput("input_year", "Year", value = 1985, min = 1985, max = 2016, sep=""),
              selectInput("input_country","Country", choices = sort(data$country)),
              radioButtons("input_gender","Sex", choices = c("Male" , "Female", "Both")),
              selectInput("input_age","Age Group", choices = sort(data$age))
            ), mainPanel(
              textOutput("table_text"),
              dataTableOutput("table"),
              tags$head(tags$style("#table_text{color:#00BFFF; font-size:20px}"))
            )
    
              )
            ),
        tabPanel("Visualization",
                 sidebarLayout(
                   sidebarPanel(selectInput("vis_year", "Year", choices = as.integer(sort(data$year))),
                                selectInput("vis_country","Country", choices = sort(data$country)),
                                radioButtons("vis_gender","Sex", choices = c("Male" , "Female", "Both"))),
                   mainPanel(
                                  textOutput("bar_title"),
                                  plotOutput("barg"),
                                  textOutput("bar_explanation"),
                                  tags$head(tags$style("#bar_title{color: #00BFFF; font-size: 20px}"))
                  )
                 )
                 ),
        tabPanel("Line Graph Visual", 
                 sidebarLayout(
                   sidebarPanel(
                     selectInput("country_for_range", "Country", choices = sort(data$country)),
                     sliderInput("input_range", "Year Range to be Displayed", 
                                 min = 1985, max = 2016, value = c(1996, 2005), sep = "")),
                     mainPanel(
                       textOutput("lineg_title"),
                       plotOutput("lineg"),
                       tags$head(tags$style("#lineg_title{ color: #00BFFF; font-size: 20px}"))
                   )
               )
               
        )
      ),tabPanel("Analysis",
                   sidebarLayout(
                     sidebarPanel(
                       selectInput("country_for_analysis", "Country", choices = sort(data$country), selected = "Albania"),
                       sliderInput("input_range_analysis", "Year Range to be Displayed", 
                                   min = 1985, max = 2016, value = c(1996, 2005), sep = "")
                     ), mainPanel(
                       textOutput("analysis_title"),
                       textOutput("analysis_introduction"),
                       textOutput("analysis"),
                       textOutput("analysis_gdp_explanation"),
                       splitLayout(cellWidths = c("50%","50%"), plotOutput("analysis_gdp"), plotOutput("analysis_suicides")),
                       textOutput("analysis_one_year_input"), 
                       selectInput("analysis_for_year", "Select One Specific Year", choices = sort(data$year)),
                       selectInput("analysis_for_sex", "Select Sex", choices = unique(data$sex)),
                       plotlyOutput("pie_analysis"),
                       
                       tags$head(tags$style("#analysis_title{ color: #00BFFF; font-size: 20px}"))
                     )
                   )
        ),tabPanel("About Us",
                   textOutput("project_descr_title"),
                   textOutput("project_description"),
                   textOutput("audience_title"),
                   textOutput("audience"), 
                   textOutput("takeaway_title"),
                   uiOutput("takeaway"),
                   textOutput("group"),
                   textOutput("kevin_title"),
                   textOutput("kevin"), 
                   textOutput("lakshay_title"),
                   textOutput("lakshay"), 
                   textOutput("ethan_title"), 
                   textOutput("ethan"),
                   textOutput("Source_Title"),
                   uiOutput("Source_link"),
                   
                   tags$head(tags$style("#project_descr_title{color: 	#00BFFF;font-size: 20px}
                                         #audience_title{color:	#00BFFF; font-size: 20px}
                                         #takeaway_title{color: 	#00BFFF; font-size: 20px}
                                         #group{ color: #00BFFF; font-size: 20px}
                                         #kevin_title{font-size: 20px}
                                         #lakshay_title{font-size: 20px}
                                         #ethan_title{ font-size: 20px}
                                         #Source_Title{ color:#00BFFF;font-size: 20px; text-align: left;}
                                         #Source_link{ text-align: justify; font-size: 15px;}"))
                
      )
   )
  )  
)

