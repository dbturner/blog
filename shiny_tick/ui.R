# Tick blog Shiny app
# Author: Dan Turner
# For more information about Mimicking a Google Form with a Shiny app, see here: https://deanattali.com/2015/06/14/mimicking-google-form-shiny/

library(shiny)
library(shinythemes)
library(shinydashboard)
library(DT)
library(shinyjs)
library(shinyWidgets)
library(purrr)
library(rnoaa)

shinyUI(fluidPage(
    setBackgroundColor(color = "#f0f0f0"),
    
    useShinyjs(),
    
    theme = shinytheme("sandstone") ,
    
    titlePanel("Shiny Tick Form"),
    
    tags$br(),
    tags$br(),
    
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
               uiOutput("table"),
               tags$br(),
               h5("*Scroll within the table to observe all columns."),
               h5("To sort by the latest entries, use the date_time column."),
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
