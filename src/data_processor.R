library(dplyr)
library(readr)
library(lubridate)

get_season <- function(month) {
  case_when(
    month %in% c(12, 1, 2) ~ "Winter",
    month %in% c(3, 4, 5) ~ "Spring",
    month %in% c(6, 7, 8) ~ "Summer",
    TRUE ~ "Fall"
  )
}

process_and_save_data <- function(
    raw_path = "data/raw/GlobalLandTemperaturesByCountry.csv",
    output_dir = "data/processed"
) {
  
  # Ensure output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  df <- read_csv(raw_path)
  
  df_processed <- df |> 
    mutate(
      dt = as.Date(dt),
      year = year(dt),
      month = month(dt)
    ) |> 
    filter(year >= 1860) |>
    rename(
      AvgTemp = AverageTemperature,
      AvgUncertain = AverageTemperatureUncertainty,
      country = Country
    ) |>
    mutate(
      season = get_season(month)
    ) |>
    select(year, month, country, AvgTemp, AvgUncertain, season)
  
  message("Saving processed data as csv")
  write_csv(df_processed, file.path(output_dir, "df_processed.csv"))
}

process_and_save_data()