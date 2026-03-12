library(shiny)
library(bslib)

######### ui components
# ==========================================
# 1. Define Inputs
# ==========================================
country_selector <- selectInput(
  "country", # input id
  "Select Country", # label
  choices = country_choices,
  selected = "Canada"
)

baseline_year_input <- numericInput(
  "baseline_year",
  "Select Reference Year:",
  value = 1950,
  min = min_year,
  max = max_year,
  step = 1,
  width = "100%"
)

target_year_input <- numericInput(
  "target_year",
  "Select Target Year:",
  value = 2000,
  min = min_year,
  max = max_year,
  step = 1,
  width = "100%"
)

# ==========================================
# 2. Define Sidebar (Collapsible)
# ==========================================
app_sidebar <- sidebar(
  country_selector,
  baseline_year_input,
  target_year_input,
  uiOutput("year_validation_ui"),
  title = "Filters",
  open = "closed", # close by default
  id = "app_sidebar"
)

# ==========================================
# 3. Define Output
# ==========================================
################### Output: Seasonal Card
seasonal_temp_card <- card(
  card_header("Seasonal Temperature"),
  tableOutput("seasonal_temp_ui"),
  class = "mb-3"
)

################### Output: Monthly Temp Line Plot
temp_plot_card <- card(
  card_header("Temperature Over Time"),
  div( # Card body with plot
    plotlyOutput("temp_plot", height = "100%", width = "100%"),
    style = "height:100%; width:100%; min-height:0; flex:1;"
  ),
  style = "height: 100%; display: flex; flex-direction: column; min-height:0;",
  class = "h-100"
)

################### Output: Data table for filtered data
table_card <- card(
  card_header(
    div(
      "Data Table",
      downloadButton("download_table_csv", "Export CSV", class = "btn-sm"),
      class = "d-flex justify-content-between align-items-center w-100"
    )
  ),
  div(
    tableOutput("data_table"),
    class = "data-table-compact"
  ),
  style = "min-height: 0; flex: 1;",
  class = "mb-3"
)


# ==========================================
# 4. Assemble to Final UI Layout
# ==========================================
################### Left column of layout(3:9): The inputs and seasonal component
left_column <- column(
  width = 3,
  wellPanel(
    h4("Filters"),
    country_selector,
    baseline_year_input,
    target_year_input
  ),
  br(),
  h4("Seasonal Temperature"),
  tableOutput("seasonal_temp_ui")
)
################### Right column of layout(3:9): The monthly line plot and table
right_column <- column(
  width = 9,
  plotlyOutput("temp_plot"),
  br(),
  table_card
)
################### Final UI layout assemble
ui_final <- fluidPage(
  titlePanel("Climate Snapshot: Temperature Comparison"),
  fluidRow(
    left_column,
    right_column
  )
)

# ui_final <- fluidPage(
#   titlePanel("Climate Snapshot: Temperature Comparison"),
#   sidebarLayout(
#     sidebarPanel(
#       country_selector,
#       baseline_year_input,
#       target_year_input
#     ),
#     mainPanel(
#       tableOutput("seasonal_temp_ui"),
#       plotlyOutput("temp_plot"),
#       table_card
#     )
#   )
# )



