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
                    tags$head(tags$style("#introduction_title{
                                         color:#00BFFF;
                                         font-size: 20px; 
                                         text-align: center;}
                                         #introduction{
                                          text-align: justify;
                                          font-size: 15px;
                                         }
                                         ")),
                    textOutput("Source_Title"),
                    uiOutput("Source_link"),
                    tags$head(tags$style("#Source_Title{
                                         color:#00BFFF;
                                         font-size: 20px; 
                                         text-align: left;}
                                         #Source_link{
                                          text-align: justify;
                                          font-size: 15px;
                                         }
                                         "))
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
              dataTableOutput("table")
            )
    
              )
            ),
        tabPanel("Visualization",
                 sidebarLayout(
                   sidebarPanel(selectInput("vis_year", "Year", choices = as.integer(sort(data$year))),
                                selectInput("vis_country","Country", choices = sort(data$country)),
                                radioButtons("vis_gender","Sex", choices = c("Male" , "Female", "Both"))),
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
                                 min = 1985, max = 2016, value = c(1996, 2005), sep = "")),
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
                       textOutput("analysis_title"),
                       textOutput("analysis_introduction"),
                       textOutput("analysis"),
                       textOutput("analysis_gdp_explanation"),
                       splitLayout(cellWidths = c("50%","50%"), plotOutput("analysis_gdp"), plotOutput("analysis_suicides")),
                       textOutput("analysis_one_year_input"), 
                       selectInput("analysis_for_year", "Select One Specific Year", choices = sort(data$year)),
                       selectInput("analysis_for_sex", "Select Sex", choices = unique(data$sex)),
                       #splitLayout(cellWidths = c("50%","50%"), selectInput("analysis_for_year"),selectInput("analysis_for_sex")),
                       plotlyOutput("pie_analysis"),
                       
                       tags$head(tags$style("#analysis_title{
                                              color: #00BFFF; 
                                              font-size: 20px
                                            }"))
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
                   textOutput("work_cite_title"),
                   
                   tags$head(tags$style("#project_descr_title{
                                          color: 	#00BFFF;
                                          font-size: 20px}
                                         #audience_title{
                                          color:	#00BFFF; 
                                          font-size: 20px}
                                         #takeaway_title{
                                          color: 	#00BFFF; 
                                          font-size: 20px}
                                         #group{
                                          color: #00BFFF;
                                          font-size: 20px}
                                         #kevin_title{
                                          font-size: 20px}
                                         #lakshay_title{
                                          font-size: 20px}
                                         #ethan_title{
                                          font-size: 20px}
                                         #work_cite_title{
                                          color: #00BFFF;
                                          font-size: 20px}"))
                   # , 
                   # 
                   # img(src = "https://scontent-sea1-1.xx.fbcdn.net/v/t1.15752-9/62124086_446626162786376_1588243610019561472_n.jpg?_nc_cat=101&_nc_oc=AQnOxRD0-nQ0lQx1pMxyPN6yCE3zQTPJuIK5mIP_Z4ZQ_hj4VdjqGaerF07A8jsoKTQ&_nc_ht=scontent-sea1-1.xx&oh=0b496315de07a536dfdc41a303807150&oe=5D8333AB", height = 325, Width = 300),
                   # img(src = "https://scontent-sea1-1.xx.fbcdn.net/v/t1.15752-9/62020322_2417304411667550_3683994252385189888_n.jpg?_nc_cat=105&_nc_oc=AQmB7eCHoKP6_KZ8LJiN2yrY96RbYmoQi2dYdVeGzea2A_XZkYZvfO3bK307Fj8uA7E&_nc_ht=scontent-sea1-1.xx&oh=87a2c3e498c59189f2089d71e7931b82&oe=5D884131", height = 325, Width = 300),
                   # img(src = "https://scontent-sea1-1.xx.fbcdn.net/v/t1.15752-9/62145612_425100261646368_780859242352476160_n.jpg?_nc_cat=111&_nc_oc=AQmW21WPpLMbGBLIEBMsXGLGuckcrKL7Wgpv0PM6mA5u1WAiWSsUeqr5x6qMaMlsJt4&_nc_ht=scontent-sea1-1.xx&oh=715111887b0dd56e8effd785a6f95d38&oe=5D920832", height = 325, Width = 300)
      )
   )
  )  
)

