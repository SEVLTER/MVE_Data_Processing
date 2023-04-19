# KM Hall
# 2022
#
# MVE Black data processing
#
#


library(tidyverse)
library(lubridate)

# contains the read_mve_in function that is used to load MVE data
source("scripts/load_MVE_data_into_R.R")

# subsets data to be >= to year requested here
filter_forward <- 2023

# folder where final data will be written
folder_out <- "output/"
  
# name of final output file - THIS NEEDS TO BE CHANGED FOR THE DIFFERENT SITES
whole_file_name <- "MVE_DesertGrassland_SoilMoistureTemperature.csv"
sub_file_name <- paste0("MVE_DesertGrassland_SoilMoistureTemperature_", filter_forward, ".csv")

# load MVE data ------------------------------------------------------------

# THIS NEEDS TO BE CHANGED FOR THE DIFFERENT SITES
mve <- read_mve_in("MVE_Black.dat") %>% 
  select(-RECORD) %>% 
  arrange(TIMESTAMP)





# filter data to years of interest
mve_sub <- mve %>% 
  filter(year(TIMESTAMP) >= filter_forward)


glimpse(mve)


# load sensor label data -----------------------------------------------

# TODO: Need this for Black and Creosote. Only have it for Blue at this point.
# sensor_labels <- read_csv("raw_data/MVE_PlainsGrassland_5TM_Sensor_Labels.csv") %>% 
#   rename(sensor_id = sensor.id)



# create a long version of the data -------------------------------------

mve_long <- mve %>% 
  pivot_longer(-TIMESTAMP, names_to = "sensor_id")

mve_sub_long <- mve_sub %>% 
  pivot_longer(-TIMESTAMP, names_to = "sensor_id")

table(mve_long$sensor_id)

# separate sensor column on _ to get various pieces of information contained in the variable into their own variables and
# adding date component variables
# TODO: THIS MAY NEED TO BE DIFFERENT FOR THE DIFFERENT SITES, depending on how many pieces the 
#   sensore variable has. 4 pieces for MVE Blue.
mve_long <- mve_long %>% 
  separate(sensor_id, into = c("plot", "depth", "sensor", "avg"), sep = "_", remove = FALSE) %>% 
  mutate(sensor = as.factor(sensor),
         plot = as.factor(plot),
         depth_f = as.factor(depth),
         depth = as.numeric(depth),
         year = year(TIMESTAMP),
         month = month(TIMESTAMP),
         day = day(TIMESTAMP),
         hour = hour(TIMESTAMP),
         minute = minute(TIMESTAMP),
         year_f = as.factor(year),
         month_f = as.factor(month),
         day_f = as.factor(day))

mve_sub_long <- mve_sub_long %>% 
  separate(sensor_id, into = c("plot", "depth", "sensor", "avg"), sep = "_", remove = FALSE) %>% 
  mutate(sensor = as.factor(sensor),
         plot = as.factor(plot),
         depth_f = as.factor(depth),
         depth = as.numeric(depth),
         year = year(TIMESTAMP),
         month = month(TIMESTAMP),
         day = day(TIMESTAMP),
         hour = hour(TIMESTAMP),
         minute = minute(TIMESTAMP),
         year_f = as.factor(year),
         month_f = as.factor(month),
         day_f = as.factor(day))

glimpse(mve_long)

table(mve_long$plot)
table(mve_long$depth)
table(mve_long$sensor)
table(mve_long$avg)

# Merge sensor data with sensor labels -------------------------------------

# TODO: uncomment once I have sensor labels

# mve_long <- mve_long %>% 
#   left_join(sensor_labels) %>% 
#   mutate(mean_f = as.factor(mean_trt),
#          var_f  = as.factor(var_trt))
# 
# mve_sub_long <- mve_sub_long %>% 
#   left_join(sensor_labels) %>% 
#   mutate(mean_f = as.factor(mean_trt),
#          var_f  = as.factor(var_trt))



# percent of missing records ----------------------------------------------

# percent of total missing for all sensors
sum(is.na(mve_long$value)) / nrow(mve_long) * 100

sum(is.na(mve_sub_long$value)) / nrow(mve_sub_long) * 100


# percent by sensor
missing_data_all <- mve_long %>% 
  group_by(sensor_id) %>% 
  summarize(percent_missing = sum(is.na(value)) / n() * 100)

missing_data_sub <- mve_sub_long %>% 
  group_by(sensor_id) %>% 
  summarize(percent_missing = sum(is.na(value)) / n() * 100)


# View(missing_data_all)
# View(missing_data_sub)

# percent by year and sensor
missing_data_all_annual <- mve_long %>% 
  group_by(year, sensor_id) %>% 
  summarize(percent_missing = sum(is.na(value)) / n() * 100)

missing_data_sub_annual <- mve_sub_long %>% 
  group_by(year, sensor_id) %>% 
  summarize(percent_missing = sum(is.na(value)) / n() * 100)


# View(missing_data_all_annual)
# View(missing_data_sub_annual)



# write data to file ----------------------------------------------
write_csv(mve_long, paste0(folder_out, whole_file_name))
write_csv(mve_sub_long, paste0(folder_out, sub_file_name))









