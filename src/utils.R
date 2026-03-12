library(dplyr)
library(readr)

# Load processed data
df_processed <- read_csv("../data/processed/df_processed.csv")

# Pre-aggregate yearly
df_yearly <- df_processed |>
  group_by(year, country) |>
  summarise(
    avg_temp = mean(AvgTemp, na.rm = TRUE),
    avg_uncertainty = mean(AvgUncertain, na.rm = TRUE),
    data_count = sum(!is.na(AvgTemp)),
    .groups = "drop"
  ) |>
  mutate(
    temp_lower = avg_temp - avg_uncertainty,
    temp_upper = avg_temp + avg_uncertainty
  ) |>
  rename(Country = country)

# Pre-aggregate seasonal
df_seasonal <- df_processed |>
  group_by(year, country, season) |>
  summarise(
    AverageTemperature = mean(AvgTemp, na.rm = TRUE),
    .groups = "drop"
  ) |>
  rename(Country = country)

# Pre-aggregate monthly
df_monthly <- df_processed |>
  group_by(year, country, month) |>
  summarise(
    AvgTemp = mean(AvgTemp, na.rm = TRUE),
    .groups = "drop"
  ) |>
  rename(Country = country)

# Global UI Configurations
country_choices <- sort(unique(df_yearly$Country))
min_year <- min(df_yearly$year)
max_year <- max(df_yearly$year)