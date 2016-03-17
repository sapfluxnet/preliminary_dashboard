
# Shiny Dashboard for SAPFLUXNET project
# by Sapfluxnet Team

# Server logic


### Libraries
library(shiny)
library(leaflet) # for maps
library(DT) # for datatables

### Once code (Code to execute only once at loading app)
## data

load('data/preliminary_data_fixed.RData')


shinyServer(function(input, output) {

  ### Interactive map
  
  # Creating the map
  output$preliminary_map <- renderLeaflet({
    leaflet(preliminary_data_fixed) %>%
      addTiles(options = tileOptions(noWrap = TRUE)) %>%
      setView(lng = 5.2, lat = 42.2, zoom = 2)
      
  })
  
  ### Data table
  output$preliminary_table <- renderDataTable({
    # TO DO
  })
  
  

})
