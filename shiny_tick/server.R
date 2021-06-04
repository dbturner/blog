#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    output$meta_data <- renderUI({
        fluidRow(
            h4(tags$em("Initial data:")),
            numericInput("id", "Occurrence ID:", ""),
            dateInput("obs_date", "Tick observation date:"),
            textInput("obs_lat", "Tick observation latitude:", ""),
            textInput("obs_lat", "Tick observation longitude:", ""),
            selectInput("obs_state", "US State:", c("",
                                                  "Alabama",
                                                  "Alaska",
                                                  "Arizona",
                                                  "Arkansas",
                                                  "California",
                                                  "Colorado",
                                                  "Connecticut",
                                                  "Delaware",
                                                  "Florida",
                                                  "Georgia",
                                                  "Hawaii",
                                                  "Idaho",
                                                  "Illinois",
                                                  "Indiana",
                                                  "Iowa",
                                                  "Kansas",
                                                  "Kentucky",
                                                  "Louisiana",
                                                  "Maine",
                                                  "Maryland",
                                                  "Massachusetts",
                                                  "Michigan",
                                                  "Minnesota",
                                                  "Mississippi",
                                                  "Missouri",
                                                  "Montana",
                                                  "Nebraska",
                                                  "Nevada",
                                                  "New Hampshire",
                                                  "New Jersey",
                                                  "New Mexico",
                                                  "New York",
                                                  "North Carolina",
                                                  "North Dakota",
                                                  "Ohio",
                                                  "Oklahoma",
                                                  "Oregon",
                                                  "Pennsylvania",
                                                  "Rhode Island",
                                                  "South Carolina",
                                                  "South Dakota",
                                                  "Tennessee",
                                                  "Texas",
                                                  "Utah",
                                                  "Vermont",
                                                  "Virginia",
                                                  "Washington",
                                                  "West Virginia",
                                                  "Wisconsin",
                                                  "Wyoming"))
            
        )
    })
    
    output$temp_data <- renderUI({
        fluidRow(
            h4(tags$em("Temperature data:")),
            textInput("temp_lag_0", "t0", ""),
            textInput("temp_lag_1", "t-1", ""),
            textInput("temp_lag_2", "t-2", ""),
            textInput("temp_lag_3", "t-3", ""),
            textInput("temp_lag_4", "t-4", ""),
            textInput("temp_lag_5", "t-5", ""),
            textInput("temp_lag_6", "t-6", "")
        )
    })
    
    observe({
        x <- input$station_50
        
        req(input$station_50)
        
        if (x == "yes") {
            updateTextInput(session, "temp_lag_0", value = "")
            updateTextInput(session, "temp_lag_1", value = "")
            updateTextInput(session, "temp_lag_2", value = "")
            updateTextInput(session, "temp_lag_3", value = "")
            updateTextInput(session, "temp_lag_4", value = "")
            updateTextInput(session, "temp_lag_5", value = "")
            updateTextInput(session, "temp_lag_6", value = "")
        }
        
        if (x == "no") {
            updateTextInput(session, "temp_lag_0", value = "NA")
            updateTextInput(session, "temp_lag_1", value = "NA")
            updateTextInput(session, "temp_lag_2", value = "NA")
            updateTextInput(session, "temp_lag_3", value = "NA")
            updateTextInput(session, "temp_lag_4", value = "NA")
            updateTextInput(session, "temp_lag_5", value = "NA")
            updateTextInput(session, "temp_lag_6", value = "NA")
        }
    })
    
    output$table <- renderUI({
        fluidRow(
            HTML("<div style ='font-size:92%' >"),
            DT::dataTableOutput("responses", width = 700),
            HTML("</div>")
        )
    })
    
    formData <- reactive({
        data <- sapply(fields, function(x) input[[x]])
        data
    })
    
    
    # When the Submit button is clicked, save the form data
    observeEvent(input$submit, {
        saveData(formData())
    })
    
    # Show the previous responses
    output$responses <- DT::renderDataTable({
        input$submit
        loadData()
    },
    editable = FALSE, rownames= FALSE, options = list(scrollX = TRUE)
    )
    
    values <- reactiveValues(date_vec = vector(length = 7))
    
    data <- eventReactive(input$date, {
        
        date_table_null$calendar_date <- map2(input$obs_date, sub_num, dateLag)
        as.data.frame(date_table_null)
        
    })
    
    output$date_table <- renderDataTable({
        data()
    })
    
    observeEvent(input$reset, {
        reset("id")
        reset("obs_date")
        reset("station")
        reset("station_distance")
        reset("station_50")
        reset("temp_lag_0")
        reset("temp_lag_1")
        reset("temp_lag_2")
        reset("temp_lag_3")
        reset("temp_lag_4")
        reset("temp_lag_5")
        reset("temp_lag_6")
        reset("temp_lag_7")
    })
    
})
