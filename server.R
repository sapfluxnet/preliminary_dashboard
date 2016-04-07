
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
library(ggplot2) # for plots
library(stringr) # for species names

# color palette for map & histogram legend
pal <- c("#D8B70A", "#02401B", "#A2A475", "#81A88D", "#972D15")

shinyServer(function(input, output) {

  ### Interactive map data
  # Creating the map
  output$preliminaryMap <- renderLeaflet({
    leaflet() %>%
      addTiles(urlTemplate = 'http://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}',
               attribution = 'Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ',
               options = tileOptions(noWrap = FALSE)) %>%
      setView(lng = 60, lat = 10, zoom = 2) #%>%
      # fitBounds(lng1 = -180, lng2 = 180, lat1 = -70, lat2 = 90) %>%
      # addCircleMarkers(lng = ~longitude, lat = ~latitude, layerId = ~site_name)
      
  })
  
  # Observer to show colors and sizes of points according to the variables
  # selected by the user
  observe({
    point_color <- input$color
    # point_size <- input$size

    # color
    color_data <- preliminary_map_data[[point_color]]
    palette <- colorFactor(pal[1:length(unique(preliminary_map_data[[point_color]]))],
                           color_data)

    # size
    # size <- preliminary_survey_fixed[[point_size]]

    # add markers to map
    leafletProxy('preliminaryMap', data = preliminary_map_data) %>%
      clearMarkers() %>%
      addCircleMarkers(lng = ~longitude, lat = ~latitude, layerId = ~site_name,
                 radius = 10,
                 fillColor = palette(color_data), fillOpacity = 0.8,
                 stroke = FALSE) %>%
      addLegend('bottomright', pal = palette, values = color_data,
                title = point_color, layerId = 'legend_color', opacity = 0.8)
  })
  
  # function to create the popups
  site_popup <- function(site, lat, lng) {
    selected_site <- preliminary_map_data[preliminary_map_data$site_name == site, ]
    popup_text <- as.character(tagList(
      tags$h4(selected_site$site_name),
      tags$strong(selected_site$country), tags$br(),
      sprintf('Sap flow method: %s', selected_site$sap_flow_method), tags$br(),
      sprintf('Approximate number of trees per species: %s',
              selected_site$aprox_numbers_tree_species), tags$br(),
      sprintf('Approximate number of growing seasons: %s',
              selected_site$aprox_years_growing_seasons), tags$br(),
      sprintf('Meteorogical data available: %s',
              selected_site$meteo_data_available), tags$br()
    ))
    leafletProxy('preliminaryMap') %>%
      addPopups(lng, lat, popup_text, layerId = site)
  }
  
  # Observer to show popups at click
  observe({
    leafletProxy('preliminaryMap') %>% clearPopups()
    
    event <- input$preliminaryMap_marker_click
    
    if (is.null(event)) {
      return()
    }
    
    isolate({
      site_popup(event$id, event$lat, event$lng)
    
    })
  })
  
  # Histogram for color variable selected
  # we need to play a little with the palette to achieve the
  # same sequence in leaflet and in ggplot, as leaflet takes
  # the colors not in order.
  
  output$histogram <- renderPlot({
    ggplot(preliminary_map_data,
           aes_string(x = input$color, fill = input$color)) +
      geom_bar(show.legend = FALSE) +
      scale_fill_manual(
        values = pal[1:length(unique(preliminary_map_data[[input$color]]))]
      ) +
      labs(title = '', x = '', y = 'Number of sites') +
      theme_minimal() +
      theme(panel.background = element_blank(),
            plot.background = element_blank(),
            axis.text.x = element_blank(),
            panel.grid = element_blank())
  },
  width = 200, height = 200, bg = 'transparent')
  
  ### Data table
  output$preliminary_table <- renderDataTable({
    
    datatable(table_data,
              extensions = list('FixedColumns' = list(leftColumns = 3),
                                'Scroller' = NULL),
              options = list(scrollX = TRUE, scrollCollapse = TRUE,
                             scrollY = 400, deferRender = TRUE,
                             pageLength = 250, dom = 'tf', autoWidth = TRUE,
                             columnDefs = list(list(width = '75px',
                                                    targets = c(1:11)),
                                               list(class = 'dt-center',
                                                    targets = c(1:11))))
    )
  })
  
  ### Facts pane, valueboxes
  output$N_sites <- renderValueBox({
    valueBox(value = length(preliminary_table_data$site_name),
             subtitle = 'sites willing to contribute',
             icon = icon('leaf'),
             color = 'olive')
  })
  
  output$N_wrong_coord <- renderValueBox({
    valueBox(value = paste((sum(!preliminary_table_data$is_inside_country)/length(preliminary_table_data$is_inside_country))*100,
                           ' %'),
             subtitle = paste(sum(!preliminary_table_data$is_inside_country), ' sites with wrong coordinates'),
             icon = icon('eye'),
             color = 'red')
  })
  
  output$Meteo_data <- renderValueBox({
    valueBox(value = paste((sum(preliminary_table_data$meteo_data_available == 'yes')/length(preliminary_table_data$meteo_data_available))*100,
                           ' %'),
             subtitle = paste(sum(preliminary_table_data$meteo_data_available == 'yes'), ' sites have environmental data'),
             icon = icon('cloud'),
             color = 'teal')
  })
  
  output$Countries <- renderValueBox({
    valueBox(value = length(unique(preliminary_table_data$country)),
             subtitle = 'different countries',
             icon = icon('globe'),
             color = 'purple')
  })
  
  output$Species <- renderValueBox({
    valueBox(value = length(species_names_trim),
             subtitle = 'different species (approx.)',
             icon = icon('tree-deciduous', lib = "glyphicon"),
             color = 'green')
  })
  
  # Site inspector pane
  output$site_sps <- renderPrint({
    site_sel <- preliminary_survey_fixed[preliminary_survey_fixed$site_name == input$site_input, ]
    sps <- str_replace_all(site_sel$species, ',', ';')
    sps <- unlist(str_split(sps, ';'))
    sps <- str_c(sps, collapse = '\n')
    cat(sps)
  })
  
  output$site_contr <- renderPrint({
    site_sel <- preliminary_survey_fixed[preliminary_survey_fixed$site_name == input$site_input, ]
    name <- str_c(site_sel$first_name, site_sel$last_name, sep = ' ')
    aff <- str_c(name, site_sel$affiliation, sep = '\n')
    contr <- str_c(aff, site_sel$country, sep = '\n')
    cat(contr)
  })
  
  output$coord_ok <- renderInfoBox({
    if (input$site_input == '') {
      infoBox('Coordinates', 'NA', icon = shiny::icon('question'),
              color = 'blue', width = 4, fill = TRUE)
    } else {
      site_sel <- preliminary_survey_fixed[preliminary_survey_fixed$site_name == input$site_input, ]
      if (site_sel$is_inside_country) {
        infoBox('Coordinates', 'OK', icon = shiny::icon('check'),
                color = 'blue', width = 4, fill = TRUE)
      } else {
        infoBox('Coordinates', 'BAD',
                icon = shiny::icon('exclamation-sign', lib = 'glyphicon'),
                color = 'red', width = 4, fill = TRUE,
                subtitle = 'Please revise coordinates')
      }
    }
  })

})
