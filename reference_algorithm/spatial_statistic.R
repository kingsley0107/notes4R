library(sf)
library(tidyverse)
library(readxl)
library(RColorBrewer)
library(classInt)
options(scipen = 100)

accident_data <- st_read(here::here("FOI/data/geo/accident","accident.geojson")) %>% st_transform(crs="+init=EPSG:4326")
road_data <- st_read(here::here("FOI/data/geo/road","distinct_road.geojson")) %>% st_transform(crs="+init=EPSG:4326")
station_data <- st_read(here::here("FOI/data/geo/stations","ATC_stations.geojson")) %>% st_transform(crs="+init=EPSG:4326")

reference_table <- read_csv(here::here("FOI/data","reference_table.csv"))
road_count_accident <- reference_table %>% group_by(gml_id) %>% summarise(accident_count=n())
road_accident_count_result <- road_data %>% select(gml_id,length,NAME,geometry) %>% left_join(road_count_accident,by='gml_id')



road_accident_count_result %>% ggplot()+geom_sf(aes(color = accident_count)) 

# road_accident_count_result %>% st_write(here::here("FOI/data/geo/road","accident_group_by_road.geojson"))

reference_table
