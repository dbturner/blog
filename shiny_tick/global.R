library(googlesheets4)
library(dplyr)

fields <- c("id",
            "obs_date",
            "station",
            "station_distance",
            "station_50",
            "temp_lag_0",
            "temp_lag_1",
            "temp_lag_2",
            "temp_lag_3",
            "temp_lag_4",
            "temp_lag_5",
            "temp_lag_6",
            "temp_lag_7") # create fields that receive an input

load("~/Documents/GitHub/blog/.secrets/noaa/noaa_token")

options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE,
  noaakey = noaa_token
) # set

table <- "responses"

date_t <- c("t0", "t-1", "t-2", "t-3", "t-4", "t-5", "t-6")
sub_num <- c(0:6)
calendar_date <- rep(NA, 7)

date_table_null <- data.frame(cbind(date_t, calendar_date))


dateLag <- function(x, y){
  x - y
}

ssid_shiny_tick <- "1l8xJ6wrxA_6WLchEnubk5ez1mjckpYvq2IZkzCYEn2M"

humanTime <- function() format(Sys.time(), "%Y.%m.%d-%H:%M:%OS")

saveData <- function(data) {
  # The data must be a dataframe rather than a named vector
  data <- data %>%
    as.list() %>%
    data.frame() %>%
    mutate(date_time = humanTime())
  # Add the data as a new row
  sheet_append(ssid_shiny_tick, data)
}

loadData <- function() {
  # Read the data
  read_sheet(ssid_shiny_tick)
}
