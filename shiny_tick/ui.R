# Tick blog Shiny app
# Author: Dan Turner
# For more information about Mimicking a Google Form with a Shiny app, see here: https://deanattali.com/2015/06/14/mimicking-google-form-shiny/

library(shiny)
library(shinythemes)
library(shinydashboard)
library(DT)
library(shinyjs)
library(shinyWidgets)
library(rnoaa)

shinyUI(fluidPage(
    setBackgroundColor(color = "#f0f0f0"),
    
    useShinyjs(),
    
    theme = shinytheme("sandstone") ,
    
    h1("Shiny Tick Data Collection Form"),
    tags$hr(),

    tags$h4("This Shiny App accompanies my blog post on using Shiny Apps for large-scale data collection.
            Read the",
            tags$a(href = "https://dbturner.github.io/blog/7June2021_shiny_ticks.html",
                   "full blog post"),
                   "for more context."),
    
    tags$h4("This App collects simple information about when an American Dog Tick was first observed in a season. 
            We obtained this data from the iNaturalist database, as mentioned in the blog post. If you'd like to
            try this out for yourself, try inputting data from", 
            tags$a(href = "https://www.inaturalist.org/observations?taxon_id=52155",
                   "any of these observations"),
            ". Previewing and submitting the data may take a few seconds for processing. See the previous sample entries
            at the bottom of the page if you need guidance."),
    
    tags$hr(),
    
    fluidRow(
        column(width = 1
        ),
        
        column(3,
               tags$head(
                   tags$style(HTML('#reset{background-color:#d43f3f}')) # This line sets the button color.
               ),
               actionButton("reset", "Reset data")
        ),
        
        column(width = 1
        ),
        
        column(6,
               tags$head(
                   tags$style(HTML('#preview{background-color:#00802b}'))
               ),
               actionButton("preview", "Preview weather table")
        )
    ),
    
    tags$br(),
    
    fluidRow(
        column(width = 1
        ),
        
        column(width = 3,
               uiOutput("meta_data")
        ),
        
        column(width = 1
        ),
        
        
        column(width = 6,
               dataTableOutput("weather_table")
        )
        
    ),
    
    tags$hr(),
    tags$hr(),
    
    fluidRow(
        column(1),
        
        column(9,
               tags$br(),
               h3("Google Sheet (previous responses):"),
               tags$br(),
               uiOutput("table"),
               tags$br(),
               h5("*Scroll within the table to observe all columns."),
               tags$br(),
               tags$br(),
               tags$head(
                   tags$style(HTML('#submit{background-color:#4f8fe8}'))
               ),
               actionButton("submit", "Submit data"),
               tags$br(),
               tags$br(),
               tags$br()
        ),
        
        column(1)
    )
)
)
