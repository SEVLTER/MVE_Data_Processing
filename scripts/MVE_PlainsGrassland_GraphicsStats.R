# KM Hall
# 2022
#
# Graphics and analysis script for MVE Soil Sensors


library(tidyverse)
library(lubridate)


# this should be a file produced from the data processing scripts
path_to_folder <- "output/"


# THIS NEEDS TO BE CHANGED FOR THE DIFFERENT SITES  
name_of_file <- "MVE_DesertGrassland_SoilMoistureTemperature.csv"


# read in file
mve <- read_csv(paste0(path_to_folder, name_of_file)) %>% 
  mutate(sensor_id = as.factor(sensor_id),
         sensor = as.factor(sensor),
         depth_f = as.factor(depth_f),
         year_f = as.factor(year_f),
         month_f = as.factor(month_f),
         day_f = as.factor(day_f),
         plot = as.factor(plot))

glimpse(mve)



# subset VWC data, exclude rows without data, make daily summary --------------------------

# NOTE: Need to filter Blue for year > 2018 - THIS SHOULD NOT BE DONE FOR OTHER SITES
vwc <- mve %>% 
  filter(year > 2018 & !is.na(value))

# make daily summary
vwc_d <- mve %>% 
  group_by(year_f, month_f, day_f, plot, mean_f, var_f, soil_depth)

