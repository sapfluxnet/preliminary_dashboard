
# Shiny Dashboard for SAPFLUXNET project
# by Sapfluxnet Team

# Shiny Dashboard for SAPFLUXNET project
# by Sapfluxnet Team

# Server logic

# This server logic is based in superzip shiny example
# (https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example)
# and amerifluxR app (https://github.com/khufkens/amerifluxr) by Koen Hufkens.


### Libraries
library(shiny)
library(leaflet) # for maps
library(DT) # for datatables

shinyServer(function(input, output) {

  ### Interactive map data
  # Creating the map
  output$preliminary_map <- renderLeaflet({
    leaflet(preliminary_survey_fixed) %>%
      addTiles(urlTemplate = 'http://korona.geog.uni-heidelberg.de/tiles/roads/x={x}&y={y}&z={z}',
               attribution = 'Imagery from <a href="http://giscience.uni-hd.de/">GIScience Research Group @ University of Heidelberg</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
               options = tileOptions(noWrap = FALSE)) %>%
      setView(lng = 0, lat = 10, zoom = 2) %>%
      # fitBounds(lng1 = -180, lng2 = 180, lat1 = -70, lat2 = 90) %>%
      addCircleMarkers(lng = ~longitude, lat = ~latitude)
      
  })
  
  ### Data table
  output$preliminary_table <- renderDataTable({
    datatable(preliminary_table_data,
              extensions = list(FixedColumns = list(leftColumns = 5),
                                Scroller = list()),
              options = list(scrollX = TRUE, scrollCollapse = TRUE,
                             scrollY = 400, deferRender = TRUE,
                             pageLength = 125))
  })
  
  

})
