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
library(plotly)

# Data read and organized to be readable in good format
data <- read.csv("data/master.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)
# Define server 

shinyServer(function(input, output) {
   
  ####################################################################
  # Introduction page and title 
  output$introduction_title <- renderText({
    intro <- paste0("An Introduction to Our Findings, Our Purpose, and Our Goal")
  })
  output$introduction <- renderText({
    text <- paste("In the world today, the problem of suicide and its continuously rising rate throughout the years have raised
                  quite a significant amount of questions and concerns. In this application, we want you to be able to examine 
                  the suicide rates in your own country (given that there is recorded data). We want you to be able to see that 
                  in the progression of years or in a span of, for example, 5 years, what the suicide rates looked like and how 
                  it has either decreased or increased. We want you to become aware and realize which age groups are most susceptible 
                  and vulnerable to suicide. We want you to see the correlation of GDP and suicide rates in general. Although we 
                  do not provide the most precise and narrow statistics and numbers to show if there is a relationship in these 
                  examinations, we present our findings in the form that you can come and see some general trends and data 
                  findings.")
  })
  
  # Data table
  output$table <- renderDataTable({
    # Warning messages for user to see if no values selected
    validate(
    
      need(input$input_country, message = "Please select country."),
      need(input$input_age, message = "Please select intended age group.")
      
    ) 
    
    # table organization
    if(input$input_gender == "Both") {
      desired_df <-  data %>%
        filter(input$input_country == country,input$input_age == age,input$input_year == year) %>% select(country,year,sex,age,suicides_no,population,suicides.100k.pop,generation)
    } else {
    desired_df <- data %>%
      filter(input$input_country == country,input$input_gender == sex,input$input_age == age,input$input_year == year) %>% select(country,year,sex,age,suicides_no,population,suicides.100k.pop,generation)
    }
  })
  
  # Bar graph for showing relationship between age group and number of suicide
  output$barg <- renderPlot({
    
    # the user selects both in the input gender widget then display bar graph with data containing both sexes
    if ( input$vis_gender == "Both") {
      both_case <- data %>% filter(input$vis_year == year, input$vis_country == country)
      
      # Error message that there is no data available (data for graph is empty)
      validate(
        need(nrow(both_case) > 1, message = "Data not available / No recorded data available.")
      )
      
      # bar graph with ggplot 
      output <- ggplot(both_case, aes(both_case$age, both_case$suicides_no, fill = both_case$sex)) + geom_bar(stat="identity", position ="dodge") +
        scale_fill_brewer(palette = "Set1") + labs(title = " A Look into Suicide numbers for each Age Group for both genders", fill = "Gender") + 
        xlab("Age Groups") + ylab("Number of Suicides") 
      output
      
    } else {
      ## the user selects either male or female in the gender selection widget
      data_filter_df <- data %>% 
        filter(input$vis_year == year, input$vis_country == country, input$vis_gender == sex)
      
      # Error message to show if data not available
      validate(
        need(input$vis_year, message = "Please select a year"),
        need(input$vis_country, message = "Please choose a country."),
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
  
  # Line graph
  output$lineg <- renderPlot({
    line_data <- data %>% 
      filter(input$country_for_range == country) %>% group_by(year) %>% summarize(suicides = sum(suicides_no)) %>% 
      filter( input$input_range[1] <= year & input$input_range[2] >= year )
   
    validate(
      need(nrow(line_data) > 1 , "Please select country.")
    )
    
    
    plot_view <- ggplot(data = line_data, aes(x = line_data$year, y = line_data$suicides)) + geom_line() + geom_point() +
                 labs(title = "A Simple Look at the Suicide Numbers in each Progressing Year") + xlab("Year") + ylab("Number of Suicides")
    plot_view
  })
  
  output$analysis <- renderText({
    analysis_data <- data %>% filter(input$country_for_analysis == country) %>% group_by(year) %>% summarize(suicides = sum(suicides_no)) %>% 
      filter( input$input_range_analysis[1] <= year & input$input_range_analysis[2] >= year ) %>% select(suicides)
    
    # Message to display if nothing selected
    validate(
      need(nrow(analysis_data) > 1, message = "Please select a country to analyze and look at.")  
    )
    
    old <- as.integer(analysis_data[1,1])
    new <- as.integer(analysis_data[nrow(analysis_data),1])
    change <- new - old
    if(old != 0){
     perc_inc <- round((change/old)*100,2)
    } else {
      perc_inc <- 0
    }
    if(change > 0 & nrow(analysis_data) > 1) {
      text <- paste0("In ", input$country_for_analysis," there was a ", perc_inc,"% increase in suicide rates.")
    } else if(change <= 0  & nrow(analysis_data) > 1){
      text <- paste0("In ", input$country_for_analysis, " there was a ", abs(perc_inc),"% decrease in suicide rates.")
    }  else {
      text <- paste0("Data is not available")
    }
    text
  })
  
  # graph in analysis that shows gdp line graph
  output$analysis_gdp <- renderPlot({
    gdp <- data %>% 
      filter(input$country_for_analysis == country) %>% select(country, year, suicides_no, gdp_per_capita....) %>% 
      group_by(country, year, gdp_per_capita....) %>% summarize(suicides = sum(suicides_no)) %>% 
      filter( input$input_range_analysis[1] <= year & input$input_range_analysis[2] >= year )
    
    validate(
      need(nrow(gdp) > 1, "Please select a country.")
    )
    
    plot <- ggplot(gdp, aes(gdp$year, gdp$gdp_per_capita....)) + geom_line() + labs(title = "A View of GDP-per-capita in each year of the Selected Nation") +
            xlab("Year") + ylab("GDP-per-capita")
    plot
  })
  
  # graph in analysis that shows suicide number line graph
  output$analysis_suicides <- renderPlot({
    test <- data %>% filter(input$country_for_analysis == country) %>% group_by(year) %>% summarize(suicides = sum(suicides_no)) %>% 
            filter( input$input_range_analysis[1] <= year & input$input_range_analysis[2] >= year )
    
    validate(
      need(nrow(test) > 1 , "Please select a country.")
    )
    
    testing <- ggplot(test, aes(test$year, test$suicides)) + geom_line() + labs(title = "A View of total suicide numbers for each year in the selected Country") +
               xlab("Year") + ylab("Total number of suicides")
    testing
  })
  
  # pie chart in analysis page
  output$pie_analysis <- renderPlotly({
    test2 <- data %>% filter(input$country_for_analysis == country, input$analysis_for_year == year, input$analysis_for_sex == sex)
    value <- test2[,5]
    
    validate( 
      need(nrow(test2) > 1,  "Please select country. If there is no plot after selecting country, for this specific year, there were no recorded data.")
    )
    
    p <- plot_ly(test2, labels = test2$age , values = value, type = 'pie') %>% layout(title = 'Percentage of Each Age Group in Comparison with Suicide Numbers') 
    p
  })
  
  # ANALYSIS TITLE 
  output$analysis_title <- renderText({
    text <- paste("Analysis")
  })
  # ANALYSIS EXPLANATIONS 
  output$analysis_introduction <- renderText({
    text <- paste("Given the information from the user-selected COUNTRY and the given range of YEARS, we are able to calculate that : ")
  })
  
  # ANALYSIS EXPLANATIONS
  output$analysis_gdp_explanation <- renderText({ 
    text <- paste("Given the information of the selected country and the year, the graphs below show the GDP in the specific range of years and
                  the graph of the number of suicides with the same range of years. With the side-by-side graphical visual representation, we can 
                  see that for most of the countries, with higher GDP, comes with also a higher number of suicides. This then, can lead to future
                  investigations of other factors such as: economics, healthcare, support, wages, etc...")
  })
 
  # ANALYSIS EXPLANATIONS
  output$analysis_one_year_input <- renderText({
    text <- paste("The following analysis enables you to view the percentage of each age group that contributes to the suicide rate given the selected
                  country. Please select a specific year and gender in the dropdown menus to view the information. ** Data make take a moment to load.")
  })
  
  #################################################################################################
  # Project description section in about us page
  output$project_descr_title <- renderText({
    title <- paste("Project Description:")
  })
  output$project_description <- renderText({
      project_description <- paste("The data that we will be examining is Suicide rates around
                                    the world based upon various catagories such as GDP, age-range,
                                    and gender across different countries. This dataset
                                    was acquired from Kaggle which pulls data from the United
                                    Nations, The World Bank, World Health Organization, and a
                                    notebook that contains records of suicides across the world.
                                    This is important for people to be able to analyze patterns
                                    and recognize specific danger areas that need help.
                                    Identifying troubling areas to send councillors and experts
                                    can help decrease suicide occurrences and possibly help
                                    communities grow.")
  })
  
  ##################################################################################################
  # Audience Section for about us page
  output$audience_title <- renderText({
    title <- paste("Audience Intended:")
  })
  output$audience <- renderText({
    expected_audience <- paste( "The target audience is adults and teenagers since the end goal is to spread awareness of mental health. 
                                 Mental health advocates and possibly doctors with the background in mental health would be able to
                                 target these zones and decrease the number of suicides;
                                 Teenagers should be more aware of the mental
                                 health of their peers as well, so targeting this broad range
                                 would help increase the awareness in a school setting and a 
                                 public setting. Looking at different demographics across the
                                 world may give people ideas on how to treat mental health 
                                 universally.")
  })
  
  #################################################################################################
  # Takeaway section for about us page
  output$takeaway_title <- renderText({
    title <- paste("Takeaways")
  })  
   output$takeaway <- renderUI({
      HTML(paste( "The audience should learn at least four key things about our dataset:", 
                  "1.) Examine the country's data concerning the number of suicides",
                  "2.) Examine and observe the suicide numbers in each given age group for that country",
                  "3.) Identify trends in a line graph that shows the total suicide rates for selected years",
                  "4.) Draw conclusions based on gdp comparisons, age comparisons, gender comparisons, and percent increase/decrease in the 
                  number of suicides",sep="<br/>"))
  })
   
  ##################################################################################################
  # About US // group members 
  output$group <- renderText({
    title <- paste("A Little Information About Us")
  })
   
  output$kevin_title <- renderText({
    paste("Kevin")
  })
  output$kevin <- renderText({ 
   bio <- paste("A freshman looking for a major. :)")
  })
  
  output$lakshay_title <- renderText({
    paste("Lakshay")
  })
  output$lakshay <- renderText({
    bio <- paste("A cool dude.")
  })
  
  output$ethan_title <- renderText({
    paste("Ethan")
  })
  output$ethan <- renderText({
    bio <- paste("A sophomore in Informatics.")
  })
  
  output$work_cite_title <- renderText({
    title <- paste("Works Cited")
  })
  
})

