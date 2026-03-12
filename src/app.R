########################## library
library(shiny)
library(bslib)
library(dplyr)


########################## load preaggregated data from utils.R
source("utils.R")


########################## UI
ui <- page_fillable(
  selectInput("country", "Country", choices = country_choices)
)

########################## server
server <- function(input, output, session) {
  
}


########################## create app
shinyApp(ui = ui, server = server)
