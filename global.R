### Load necessary libraries and data
library(dplyr)
library(stringr)
# Preliminary data
load('data/preliminary_data_fixed.RData')

# utf8 encoding
# for(i in 1:length(names(preliminary_survey_fixed))){
#   preliminary_survey_fixed[,i] <- stri_enc_tonative(preliminary_survey_fixed[,i])
# }

# reordering variables and drop the ones not important now
preliminary_table_data <- preliminary_survey_fixed %>%
  select(country, site_name, longitude, latitude,
         affiliation, sap_flow_method, growth_condition,
         aprox_numbers_tree_species, aprox_years_growing_seasons,
         is_inside_country, meteo_data_available)

# simplifing the variables to map representation
preliminary_map_data <- preliminary_table_data %>%
  mutate(sap_flow_method = factor(sap_flow_method, levels = c(
    'constant_heat_dissipation', 'heat_ratio_method', 'stem_heat_balance',
    'trunk_segment_heat_balance', 'other_slash_unknown', 'sapflow_plus',
    'compensating_heat_pulse', 'cyclic_heat_dissipation', 'heat_field_deformation',
    'heat_pulse_tmax_method'
  )),
  growth_condition = factor(growth_condition, levels = c(
    'nat_stand_unmanaged', 'plant_slash_managed_stand', 'orchard',
    'other_unknown'
  )),
  aprox_numbers_tree_species = factor(aprox_numbers_tree_species,
                                      levels = c(
                                        'less_than_3',
                                        'between_3_and_5',
                                        'between_5_and_10',
                                        'greater_than_10',
                                        'unknown'
                                      )),
  is_inside_country = factor(is_inside_country),
  meteo_data_available = factor(meteo_data_available))

table_data <- preliminary_map_data %>%
  rename(n_trees_aprox = aprox_numbers_tree_species,
         n_seasons = aprox_years_growing_seasons,
         coord_correct = is_inside_country,
         meteo_data = meteo_data_available)

levels(preliminary_map_data$sap_flow_method) <- c("Constant Heat Dissipation",
                                                  "Heat Ratio",
                                                  "Steam Heat Balance",
                                                  "Trunk Segment Heat Balance",
                                                  "Other",
                                                  "Other", "Other",
                                                  "Other", "Other",
                                                  "Other")

levels(preliminary_map_data$growth_condition) <- c('Natural Stand Unmanaged',
                                                   'Plantation / Managed Stand',
                                                   'Orchard',
                                                   'Other')

levels(preliminary_map_data$aprox_numbers_tree_species) <- c('<3', '3-5', '5-10',
                                                             '>10', '?')

levels(preliminary_map_data$is_inside_country) <- c('No', 'Yes')

levels(preliminary_map_data$meteo_data_available) <- c('No', 'Yes')

# Species

species_names <- vector()

for (field in preliminary_survey_fixed$species) {
  res <- unlist(str_split(field, ';'))
  species_names <- c(species_names, res)
}

species_names_trim <- unique(species_names)
  

