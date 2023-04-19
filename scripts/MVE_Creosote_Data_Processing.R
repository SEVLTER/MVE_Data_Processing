# KM Hall
# 2022
#
# MVE Creosote data processing
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
whole_file_name <- "MVE_Creosote_SoilMoistureTemperature.csv"
sub_file_name <- paste0("MVE_Creosote_SoilMoistureTemperature_", filter_forward, ".csv")

# load MVE data ------------------------------------------------------------

# THIS NEEDS TO BE CHANGED FOR THE DIFFERENT SITES
mve <- read_mve_in("MVE_Creosote.dat") %>% 
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
  separate(sensor_id, into = c("sensor", "piece1", "piece2", "piece3", "avg"), sep = "_", remove = FALSE) %>% 
  mutate(sensor = as.factor(sensor),
         # plot = as.factor(plot),
         # depth_f = as.factor(depth),
         # depth = as.numeric(depth),
         year = year(TIMESTAMP),
         month = month(TIMESTAMP),
         day = day(TIMESTAMP),
         hour = hour(TIMESTAMP),
         minute = minute(TIMESTAMP),
         year_f = as.factor(year),
         month_f = as.factor(month),
         day_f = as.factor(day))

mve_sub_long <- mve_sub_long %>% 
  separate(sensor_id, into = c("sensor", "piece1", "piece2", "piece3", "avg"), sep = "_", remove = FALSE) %>% 
  mutate(sensor = as.factor(sensor),
         # plot = as.factor(plot),
         # depth_f = as.factor(depth),
         # depth = as.numeric(depth),
         year = year(TIMESTAMP),
         month = month(TIMESTAMP),
         day = day(TIMESTAMP),
         hour = hour(TIMESTAMP),
         minute = minute(TIMESTAMP),
         year_f = as.factor(year),
         month_f = as.factor(month),
         day_f = as.factor(day))

glimpse(mve_long)


# for creosote data, have to piece together the plot info because it ends up in various variables when 
# separating due to the structure of the sensor_id var
table(mve_long$sensor)
table(mve_long$piece1)
table(mve_long$piece2)
table(mve_long$piece3)
table(mve_long$avg)

# creating proper variables for plot and depth using an intermediate data sets
mve_long_tst <- mve_long %>% 
  mutate(plot1split = ifelse(piece1 %in% c(2, 3), NA, piece1),
         plot2split = ifelse(piece2 %in% c(12, 22, 37), NA, piece2),
         depth1split = ifelse(piece2 %in% c(12, 22, 37), piece2, NA),
         depth2split = ifelse(piece3 %in% c(12, 22, 37), piece3, NA),
         plot_extra = ifelse(piece1 %in% c(2, 3), piece1, NA),
         plot = ifelse((!is.na(plot1split) & is.na(plot2split)), plot1split, plot2split),
         depth = ifelse((!is.na(depth1split) & is.na(depth2split)), depth1split, depth2split),
         plot_extra = ifelse(piece1 %in% c(2, 3), piece1, NA)) %>% 
  select(-avg)

table(mve_long_tst$sensor)
table(mve_long_tst$piece1)
table(mve_long_tst$piece2)
table(mve_long_tst$plot)
table(mve_long_tst$piece3)
table(mve_long_tst$avg)
table(mve_long_tst$depth)
table(mve_long_tst$plot_extra)
table(is.na(mve_long_tst$plot))
table(is.na(mve_long_tst$depth))


mve_sub_long_tst <- mve_sub_long %>% 
  mutate(plot1split = ifelse(piece1 %in% c(2, 3), NA, piece1),
         plot2split = ifelse(piece2 %in% c(12, 22, 37), NA, piece2),
         depth1split = ifelse(piece2 %in% c(12, 22, 37), piece2, NA),
         depth2split = ifelse(piece3 %in% c(12, 22, 37), piece3, NA),
         plot_extra = ifelse(piece1 %in% c(2, 3), piece1, NA),
         plot = ifelse((!is.na(plot1split) & is.na(plot2split)), plot1split, plot2split),
         depth = ifelse((!is.na(depth1split) & is.na(depth2split)), depth1split, depth2split)) %>% 
  select(-avg)



table(mve_sub_long_tst$sensor)
table(mve_sub_long_tst$piece1)
table(mve_sub_long_tst$piece2)
table(mve_sub_long_tst$plot)
table(mve_sub_long_tst$piece3)
table(mve_sub_long_tst$avg)
table(mve_sub_long_tst$depth)
table(mve_sub_long_tst$plot_extra)
table(is.na(mve_sub_long_tst$plot))
table(is.na(mve_sub_long_tst$depth))


# update data after testing variables
mve_long <- mve_long_tst %>% 
  mutate( plot = as.factor(plot),
    depth_f = as.factor(depth),
    depth = as.numeric(depth)) %>% 
  select(-c(piece1, piece2, piece3, plot1split, plot2split, depth1split, depth2split))
  
mve_sub_long <- mve_sub_long_tst %>% 
  mutate( plot = as.factor(plot),
          depth_f = as.factor(depth),
          depth = as.numeric(depth)) %>% 
  select(-c(piece1, piece2, piece3, plot1split, plot2split, depth1split, depth2split))


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









