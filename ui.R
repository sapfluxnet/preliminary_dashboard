
# Shiny Dashboard for SAPFLUXNET project
# by Sapfluxnet Team

# UI logic

library(shiny)
library(shinydashboard)
library(leaflet)

## Header for dashboard
header <- dashboardHeader(title = 'SAPFLUXNET Dashboard')

## Sidebar for dashboard
sidebar <- dashboardSidebar(
  sidebarMenu(
    # Preliminary survey section
    menuItem("Preliminary Survey", tabName = 'preliminary',
             icon = icon('dashboard')),
    # TO DO more sections
    menuItem('More sections (TO DO)', tabName = 'none',
             icon = icon('warning'))
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
          id = 'preliminary',
          # Tab1, map
          tabPanel('Map', leafletOutput('preliminary_map')),
          # Tab2, data table
          tabPanel('Data', tableOutput('preliminary_table'))
        )
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