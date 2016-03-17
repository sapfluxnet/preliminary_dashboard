### Load necessary libraries and data
library(dplyr)
library(stringi)
# Preliminary data
load('data/preliminary_data_fixed.RData')

# utf8 encoding
for(i in 1:length(names(preliminary_survey_fixed))){
  preliminary_survey_fixed[,i] <- stri_enc_tonative(preliminary_survey_fixed[,i])
}

# reordering variables and drop the ones not important now

preliminary_table_data <- preliminary_survey_fixed %>%
  select(country, site_name, longitude, latitude,
         affiliation, sap_flow_method, growth_condition,
         aprox_numbers_tree_species, aprox_years_growing_seasons,
         is_inside_country, meteo_data_available)