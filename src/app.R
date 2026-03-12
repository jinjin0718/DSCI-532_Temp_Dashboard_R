########################## library
library(shiny)
library(bslib)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)


########################## load other .R files as import
source("utils.R") # preaggregated data from utils.R
source("ui.R") # import the final ui object from ui.R


#################################################################### server
server <- function(input, output, session) {
  
  ############################### Reactive Validate Input Years
  selected_years <- reactive({
    
    # Use input if available, otherwise default values
    b <- if (!is.null(input$baseline_year)) input$baseline_year else 1950
    t <- if (!is.null(input$target_year)) input$target_year else 2000
    
    # Validate
    if (b < min_year || b > max_year) b <- min_year
    if (t < min_year || t > max_year) t <- max_year
    if (t <= b) t <- b + 1  # ensure target > baseline
    
    message("selected_years reactive ran: baseline =", b, "target =", t)
    list(baseline = b, target = t)
  })
  
  ############################### Reactive Validate Input Country
  selected_country <- reactive({
    country <- if (!is.null(input$country)) input$country else "Canada"
    message("selected_country reactive ran: country =", country)
    country
  })
  
  ############################### Reactive Filter df_monthly based on inputs
  filter_df_monthly <- reactive({
    years <- selected_years()
    country <- selected_country()
    req(years)
    df_monthly |> 
      filter(
        Country == country,
        year %in% c(years$baseline, years$target)
      )
  })
  
  ############################### Reactive Filter df_seasonal based on inputs
  filter_df_seasonal <- reactive({
    years <- selected_years()
    country <- selected_country()
    req(years)
    df_seasonal |> 
      filter(
        Country == country,
        year %in% c(years$baseline, years$target)
      )
  })
  
  ############################### Reactive: Monthly comparison wide format
  # """Table of monthly comparison in wide format (3 rows x 12 columns)."""
  # """Export monthly comparison data (wide format) as CSV."""
  # """Generate download filename from current filters."""
  monthly_comparison_wide <- reactive({
    df <- filter_df_monthly()
    years <- selected_years()
    month_labels <- c("Jan","Feb","Mar","Apr","May","Jun",
                      "Jul","Aug","Sep","Oct","Nov","Dec")
    base <- df |> 
      filter(year == years$baseline) |> 
      select(month, AvgTemp)
    target <- df |> 
      filter(year == years$target) |> 
      select(month, AvgTemp)
    
    merged <- base |> 
      left_join(target, by = "month", suffix = c("_baseline","_target")) |> 
      mutate(Change = AvgTemp_target - AvgTemp_baseline,
             Month = month_labels[month]) |> 
      select(Month, AvgTemp_baseline, AvgTemp_target, Change)
    
    tibble(
      Metric = c("Baseline (°C)", "Target (°C)", "Change (°C)"),
      !!!setNames(
        lapply(1:12, function(i) round(c(
          merged$AvgTemp_baseline[i],
          merged$AvgTemp_target[i],
          merged$Change[i]
        ), 2)),
        merged$Month
      )
    )
  })
  
  ############################### Render UI: Data Table (monthly comparison wide)
  output$data_table <- renderTable({
    monthly_comparison_wide()
  })
  
  
  ############################### CSV Download: Export monthly comparison
  output$download_table_csv <- downloadHandler(
    filename = function() {
      paste0("monthly_comparison_", input$country, ".csv")
    },
    content = function(file) {
      write.csv(monthly_comparison_wide(), file, row.names = FALSE)
    }
  )
  
  
  ############################### Reactive: Seasonal Table wide format
  seasonal_table_wide <- reactive({
    df <- filter_df_seasonal()
    years <- selected_years()
    req(df, years)
    
    # Pivot wider using AverageTemperature
    df_wide <- df %>%
      filter(year %in% c(years$baseline, years$target)) %>%
      select(season, year, AverageTemperature) %>%
      pivot_wider(
        names_from = year,
        values_from = AverageTemperature,
        names_prefix = "Year_"
      )
    
    # Create column names for baseline and target
    baseline_col <- paste0("Year_", years$baseline)
    target_col <- paste0("Year_", years$target)
    
    # Add Change column
    df_wide <- df_wide %>%
      mutate(Change = !!sym(target_col) - !!sym(baseline_col)) %>%
      rename(
        Baseline = !!sym(baseline_col),
        Target = !!sym(target_col)
      ) %>%
      mutate(
        season = factor(season, levels = c("Spring","Summer","Fall","Winter"))
      ) %>%
      arrange(season) %>%
      mutate(across(c(Baseline, Target, Change), ~ round(.x, 1))) %>%
      rename(Season = season)
    
    df_wide
  })
  
  
  ############################### Render UI: Seasonal Card
  # """Render a table comparing seasonal temperatures for baseline vs target year."""
  output$seasonal_temp_ui <- renderTable({
    seasonal_table_wide()
  }, rownames = FALSE)

  
  ############################### Render UI: Monthly Temp Line Plot
  # """Render monthly dual-line comparison: baseline vs target year avg temps."""
  output$temp_plot <- renderPlotly({
    df <- filter_df_monthly()
    years <- selected_years()
    
    df_long <- df |> 
      filter(year %in% c(years$baseline, years$target)) |> 
      mutate(Year = factor(year)) # to color -> make it factor type
    
    p <- ggplot(df_long, aes(x = month, y = AvgTemp, color = Year)) +
      geom_line(size = 1.2) +
      geom_point(size = 2) +
      scale_x_continuous(breaks = 1:12, labels = month.abb) +
      labs(x = "Month", y = "Average Temperature (°C)",
           title = paste("Monthly Temperature:", input$country)) +
      theme_minimal() +
      theme(legend.title = element_blank())
    
    ggplotly(p)
  })
  
}


#################################################################### create app
shinyApp(ui = ui_final, server = server)
