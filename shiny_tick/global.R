library(googlesheets4)
library(dplyr)
library(here)

# Set fields to fill that will appended to the Google Sheet.
fields <- c("tdate", 
            "tavg", 
            "tmin", 
            "tmax", 
            "obs_id", 
            "obs_date", 
            "obs_lat", 
            "obs_lon", 
            "obs_state", 
            "station_name", 
            "station_id", 
            "distance")

# Load NOAA Token. See here for more details about getting NOAA token and other NOAA functions used in this Shiny App: https://docs.ropensci.org/rnoaa/
# load(here("shiny_tick/.secrets/noaa/noaa_token"))

# Set keys and tokens for APIs.
options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE,
  noaakey = load(here(".secrets/noaa/noaa_token")) # set these paths to whatever location works best for you to keep these tokens private
)

# Fill table with the responses that are in the Google Sheet. This line is important for the "server.R" file.
table <- "responses"

# Create a data frame with information from all NOAA and affiliated stations.
stations <- rnoaa::ghcnd_stations()

# Set the Google Sheet id.
ssid_shiny_tick <- "1l8xJ6wrxA_6WLchEnubk5ez1mjckpYvq2IZkzCYEn2M"

# Set function to save the data loaded in the Shiny session.
saveData <- function(data) {
  data <- as.data.frame(data) # Make sure the data object that has all the weather information is a data frame
  
  sheet_append(ssid_shiny_tick, data) # Append all 31 rows to the Google Sheet.
}

# Set functin to load the data in the Google Sheet.
loadData <- function() {
  # Read the data
  read_sheet(ssid_shiny_tick)
}
