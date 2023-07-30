library(tidyverse)
library(readxl)
library(sf)
options(scipen = 999)
# 
accident_data <- st_read(here::here("FOI/data/geo/accident","accident.geojson")) %>% st_transform(crs="+init=EPSG:4326")
road_data <- st_read(here::here("FOI/data/geo/road","accident_related_roads.geojson")) %>% st_transform(crs="+init=EPSG:4326")
station_data <- st_read(here::here("FOI/data/geo/stations","ATC_stations.geojson")) %>% st_transform(crs="+init=EPSG:4326")

ggplot() +
  geom_sf(data = road_data, color = "grey", size = 1)+
  geom_sf(data=accident_data,color='red',size=1)
 

accident2road_reference <- st_nearest_feature(accident_data,road_data)

nrow(accident_data)
road_data[accident2road_reference,]$gml_id
accident_data_merge_table <- select(accident_data,accident_index,accident_reference,accident_year,date,time,geometry)
accident_data_merge_table['gml_id'] = road_data[accident2road_reference,]$gml_id
accident_data_merge_table

road2station_reference <- road_data %>% st_nearest_feature(station_data)
road_data_copy <- select(road_data,gml_id)
station_reference <- station_data[road2station_reference,]
road_data_copy['Site_No'] <- station_reference$Site_No
right <- road_data_copy %>% as_tibble() %>% select(gml_id,Site_No)
left <- accident_data_merge_table %>% as_tibble()%>% select(accident_index,accident_reference,accident_year,date,time,gml_id) 

accident2road2station <- left %>% left_join(distinct(right),by='gml_id')
accident2road2station %>% write_csv(here::here("FOI/data","accident_road_station.csv"))
