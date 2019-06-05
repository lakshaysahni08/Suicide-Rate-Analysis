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
                                 min = 1985, max = 2016, value = c(1996, 2005),, sep = "")),
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
                                   min = 1985, max = 2016, value = c(1996, 2005), sep = "")
                     ), mainPanel(
                       textOutput("analysis"),
                       splitLayout(cellWidths = c("50%","50%"), plotOutput("analysis_gdp"), plotOutput("analysis_suicides")),
                       selectInput("analysis_for_year", "Select One Specific Year", choices = sort(data$year)),
                       selectInput("analysis_for_sex", "Select Sex", choices = unique(data$sex)),
                       #splitLayout(cellWidths = c("50%","50%"), selectInput("analysis_for_year"),selectInput("analysis_for_sex")),
                       plotlyOutput("pie_analysis")
                     )
                   )
        ),tabPanel("About Us",
                   textOutput("About_us"),
                   img(src = "https://scontent-sea1-1.xx.fbcdn.net/v/t1.15752-9/62124086_446626162786376_1588243610019561472_n.jpg?_nc_cat=101&_nc_oc=AQnOxRD0-nQ0lQx1pMxyPN6yCE3zQTPJuIK5mIP_Z4ZQ_hj4VdjqGaerF07A8jsoKTQ&_nc_ht=scontent-sea1-1.xx&oh=0b496315de07a536dfdc41a303807150&oe=5D8333AB", height = 325, Width = 300),
                   img(src = "https://scontent-sea1-1.xx.fbcdn.net/v/t1.15752-9/62020322_2417304411667550_3683994252385189888_n.jpg?_nc_cat=105&_nc_oc=AQmB7eCHoKP6_KZ8LJiN2yrY96RbYmoQi2dYdVeGzea2A_XZkYZvfO3bK307Fj8uA7E&_nc_ht=scontent-sea1-1.xx&oh=87a2c3e498c59189f2089d71e7931b82&oe=5D884131", height = 325, Width = 300),
                   img(src = "https://scontent-sea1-1.xx.fbcdn.net/v/t1.15752-9/62145612_425100261646368_780859242352476160_n.jpg?_nc_cat=111&_nc_oc=AQmW21WPpLMbGBLIEBMsXGLGuckcrKL7Wgpv0PM6mA5u1WAiWSsUeqr5x6qMaMlsJt4&_nc_ht=scontent-sea1-1.xx&oh=715111887b0dd56e8effd785a6f95d38&oe=5D920832", height = 325, Width = 300)
                   
      )
    
   )
  )  
)

