# KM Hall
# 2023
#
# This program combines MVE data in long format across multiple years by site.


library(tidyverse)


# blue -----
blue2018 <- read_csv("output/MVE_PlainsGrassland_SoilMoistureTemperature_2018.csv")
blue2019 <- read_csv("output/MVE_PlainsGrassland_SoilMoistureTemperature_2019.csv")
blue2020 <- read_csv("output/MVE_PlainsGrassland_SoilMoistureTemperature_2020.csv")
blue2021 <- read_csv("output/MVE_PlainsGrassland_SoilMoistureTemperature_2021.csv")
blue2022 <- read_csv("output/MVE_PlainsGrassland_SoilMoistureTemperature_2022.csv")
blue2023 <- read_csv("output/MVE_PlainsGrassland_SoilMoistureTemperature_2023.csv")

blue <- rbind(blue2018, blue2019, blue2020, blue2021, blue2022, blue2023) |> 
  arrange(TIMESTAMP, plot)

write_csv(blue, "output/MVE_PlainsGrassland_SoilMoistureTemperature_2018_to_2023.csv")


# black -----
black2019 <- read_csv("output/MVE_DesertGrassland_SoilMoistureTemperature_2019.csv")
black2020 <- read_csv("output/MVE_DesertGrassland_SoilMoistureTemperature_2020.csv")
black2021 <- read_csv("output/MVE_DesertGrassland_SoilMoistureTemperature_2021.csv")
black2022 <- read_csv("output/MVE_DesertGrassland_SoilMoistureTemperature_2022.csv")
black2023 <- read_csv("output/MVE_DesertGrassland_SoilMoistureTemperature_2023.csv")

black <- rbind(black2019, black2020, black2021, black2022, black2023) |> 
  arrange(TIMESTAMP, plot)

write_csv(black, "output/MVE_DesertGrassland_SoilMoistureTemperature_2019_to_2023.csv")


# creosote -----  
creosote2022 <- read_csv("output/MVE_Creosote_SoilMoistureTemperature_2022.csv")
creosote2023 <- read_csv("output/MVE_Creosote_SoilMoistureTemperature_2023.csv")

creosote <- rbind(creosote2022, creosote2023)

write_csv(creosote, "output/MVE_Creosote_SoilMoistureTemperature_2022_to_2023.csv")


# pj -----
pj2022 <- read_csv("output/MVE_PJ_SoilMoistureTemperature_2022.csv")
pj2023 <- read_csv("output/MVE_PJ_SoilMoistureTemperature_2023.csv")

pj <- rbind(pj2022, pj2023)

write_csv(pj, "output/MVE_PJ_SoilMoistureTemperature_2022_to_2023.csv")


# jsav -----
jsav2022 <- read_csv("output/MVE_JSav_SoilMoistureTemperature_2022.csv")
jsav2023 <- read_csv("output/MVE_JSav_SoilMoistureTemperature_2023.csv")

jsav <- rbind(jsav2022, jsav2023)

write_csv(jsav, "output/MVE_JSav_SoilMoistureTemperature_2022_to_2023.csv")

