## This script sources the sub-scripts needed for our project!

#==================#
#=== PARAMETERS ===#
#==================#

# set relevant parameters
trials <- 10
women_team_combos <- NA # if you only want to run a certain number of team combos instead of all
men_team_combos <- NA # if you only want to run a certain number of team combos instead of all

# vector of apparatus competition events 
womens_apparatus <- c('fx', 'vt', 'bb', 'ub')
mens_apparatus   <- c('fx', 'vt', 'hb', 'pb', 'sr', 'ph')

# select countries that will compete in the Olympics
womens_known_qualifiers <- c('USA', 'CAN', 'GBR', 'CHN', 'BRA', 'ITA',
                             'NED', 'FRA', 'JPN', 'AUS', 'ROU', 'KOR')
mens_known_qualifiers   <- c('CHN', 'JPN', 'GBR', 'USA', 'CAN', 'GER',
                             'ITA', 'SUI', 'ESP', 'TUR', 'NED', 'UKR')

#===================#
#=== RUN SCRIPTS ===#
#===================#

# Grab data
source("Case_Study_1-Gymnastics/00_get_data.R")

# Prepare and clean data for modeling
source("Case_Study_1-Gymnastics/10_prep_data.R")
source("Case_Study_1-Gymnastics/15_qualifying_gymnast_data_prep.R")

# Run initial models to predict scores and variance for each athlete
source("Case_Study_1-Gymnastics/20_mixed_effects_model.R")
source("Case_Study_1-Gymnastics/25_fit_model.R")

# Prepare for team selection (create combinations of teams, etc)
source("Case_Study_1-Gymnastics/30_prepare_to_select.R")
source("Case_Study_1-Gymnastics/35_define_team_selection_functions.R")

# Use predicted scores and additional considerations/probabilities to select team
source("Case_Study_1-Gymnastics/40_select_female_team.R")
# source("Case_Study_1-Gymnastics/40_select_male_team.R")

# Last step: Create final output (not sure what this will look like yet exactly, 
# so not creating a script for now)
# source("Case_Study_1-Gymnastics/50_export_output.R")
