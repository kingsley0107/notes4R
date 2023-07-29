library(sf)
library(tidyverse)
library(readxl)

# target boroughs codes
TARGET_ARES = c("E09000033","E09000022","E09000030")

# read road
road_data <- st_read(here::here("FOI/data/geo/road","london_selected.geojson")) %>% st_transform(crs="+init=EPSG:4326")


# read accident
accident_data <- st_read(here::here("FOI/data/geo/accident","accident.geojson")) %>% st_transform(crs="+init=EPSG:4326")

ggplot() +
  geom_sf(data = road_data, color = "grey", size = 1)+
  geom_sf(data=accident_data,color='red',size=1)+geom_sf(data = accident_data[1,], color = "blue", size = 2)+
  geom_sf(data=road_data[3735,],color='green',size=3)

associated_road_index <- st_nearest_feature(accident_data,road_data)

related_road <- road_data[associated_road_index,]

# st_write(related_road,here::here("FOI/data/geo/road","accident_related_roads.geojson"))
