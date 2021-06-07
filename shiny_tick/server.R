library(shiny)

shinyServer(function(input, output, session) {
    
    # Create input boxes for the iNaturalist observation data.
    output$meta_data <- renderUI({
        fluidRow(
            h4(tags$em("Initial data:")),
            textInput("obs_id", "Observation ID (digits at the end of obs. URL):", ""),
            dateInput("obs_date", "Tick observation date:"),
            textInput("obs_lat", "Tick observation latitude:", ""),
            textInput("obs_lon", "Tick observation longitude:", ""),
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
    
    
    # After clicking the preview weather data table button, perform all these actions.
    weather_data <- eventReactive(input$preview, {
        
        obs_lat_lon <- data.frame(id = input$obs_state, 
                                  latitude = input$obs_lat, 
                                  longitude = input$obs_lon)
        
        nearby_stations <- meteo_nearby_stations(lat_lon_df = obs_lat_lon, 
                                                 radius = 100)
        nearby_stations <- nearby_stations[[1]]
        
        nearby_stations_abr <- stations %>%
            semi_join(nearby_stations, by = "id") %>%
            filter(element == "TAVG",
                   last_year == 2021, 
                   grepl("^US", id))
        
        key_stations <- nearby_stations %>%
            semi_join(nearby_stations_abr) 
        
        obs_date_lag <- (as.Date(input$obs_date) - 30) 
        
        weather <- meteo_tidy_ghcnd(stationid = key_stations[1,1], 
                                    date_min = obs_date_lag, 
                                    date_max = input$obs_date) %>%
            left_join(key_stations)  %>%
            rename(station_id = id,
                   tdate = date,
                   station_name = name)
        
        weather <- weather %>%
            mutate(obs_id = rep(input$obs_id, length(weather$tdate)),
                   obs_date = as.character(rep(input$obs_date, length(weather$tdate))),
                   obs_lat = rep(input$obs_lat, length(weather$tdate)),
                   obs_lon = rep(input$obs_lon, length(weather$tdate)),
                   obs_state = rep(input$obs_state, length(weather$tdate)),
                   tdate = as.character(tdate)) %>%
            select(tdate, tavg, tmin, tmax, obs_id, obs_date, obs_lat, obs_lon, obs_state, station_name, station_id, distance)
        
        as.data.frame(weather)
        
    })
    
    
    # Render the weather data table on the top right panel.
    output$weather_table <- renderDataTable({
        weather_data()},
        editable = FALSE, rownames= FALSE, options = list(scrollX = TRUE)
    )

    
    # Save the weather data by clicking the submit button.
    observeEvent(input$submit, {
        saveData(weather_data())
    })
    
    # Render and refresh the Google Sheet when the app is opened or when submitting new data.
    output$responses <- DT::renderDataTable({
        input$submit
        loadData()
    },
    editable = FALSE, rownames= FALSE, options = list(scrollX = TRUE)
    )
    
    # Create table with some aesthetic formatting.
    output$table <- renderUI({
        fluidRow(
            HTML("<div style ='font-size:92%' >"),
            DT::dataTableOutput("responses"),
            HTML("</div>")
        )
    })
    
    # If you want to put a new entry in the same session, reset the input boxes by clicking the reset button.
    observeEvent(input$reset, {
        reset("obs_id")
        reset("obs_date")
        reset("obs_lat")
        reset("obs_lon")
        reset("obs_state")
    })
    
})
