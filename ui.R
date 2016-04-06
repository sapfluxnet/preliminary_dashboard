
# Shiny Dashboard for SAPFLUXNET project
# by Sapfluxnet Team

# UI logic

library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)

# Variables for dropdowns in map
color_vars <- c('Sap Flow Method' = 'sap_flow_method',
                'Growth Condition' = 'growth_condition',
                'Are coordinates correct?' = 'is_inside_country',
                'Site with meteorological data available?' = 'meteo_data_available',
                'Species number (approximate)' = 'aprox_numbers_tree_species')

# size_vars <- c('Approximate number of species' = 'aprox_numbers_tree_species',
#                'Approximate number of growing seasons' = 'aprox_years_growing_seasons')


## Header for dashboard
header <- dashboardHeader(title = 'SAPFLUXNET Dashboard', titleWidth = 300)

## Sidebar for dashboard
sidebar <- dashboardSidebar(
  width = 300,
  sidebarMenu(
    # Preliminary survey section
    menuItem("Map & Data table", tabName = 'preliminary',
             icon = icon('globe')),
    # Facts section
    menuItem('Metadata facts', tabName = 'Facts',
             icon = icon('flask'),
             badgeLabel = "new/experimental", badgeColor = "orange"),
    # TO DO more sections
    menuItem('More sections', tabName = 'none',
             icon = icon('warning'),
             badgeLabel = 'under construction', badgeColor = 'yellow')
  )
)

## Body for dashboard
body <- dashboardBody(
  tabItems(
    # Preliminary survey tab
    tabItem(
      tabName = 'preliminary',
      fluidRow(
        tabBox(
          id = 'preliminary', width = 12, height = 600,
          # Tab1, map
          tabPanel('Map',
                   tags$head(
                     # Include our custom CSS
                     includeCSS("styles.css")
                   ),
                   leafletOutput('preliminaryMap', height = 600),
                   absolutePanel(id = 'controls', class = 'panel panel-default',
                                 draggable = TRUE, top = 70, left = "auto",
                                 right = 40, bottom = "auto",
                                 width = 250, height = 400,
                                 h2('Preliminary Data Explorer'),
                                 selectInput('color', 'Color', color_vars,
                                             selected = 'sap_flow_method'),
                                 # selectInput('size', 'Size', size_vars),
                                 plotOutput('histogram')),
                   tags$div(id = 'thanks',
                            'Sapfluxnet Team wish to thank all early ',
                            'contributors that provided this metadata.')),
          # Tab2, data table
          tabPanel('Data', dataTableOutput('preliminary_table',
                                           width = '90%', height = 600))
        )
      )
    ),
    
    # Facts
    tabItem(
      tabName = 'Facts',
      fluidRow(
        valueBoxOutput('N_sites', 4),
        valueBoxOutput('Countries', 4),
        valueBoxOutput('Species', 4)
        
      ),
      fluidRow(
        valueBoxOutput('N_wrong_coord', 4),
        valueBoxOutput('Meteo_data', 4)
      )
    ),
    
    # More sections
    tabItem(tabName = 'none',
            h2('Building more awesome widgets and visualizations ;)'),
            br(),
            h3('Please visit us again in a few days'))
  )
)


## Build the dashboard

dashboardPage(header, sidebar, body, skin = 'green')