library(stats19)
library(tidyverse)
library(readxl)
library(sf)
accident_19 <- get_stats19(year = 2019, type = "casualty")
tail(accident_19)

ATC_data <- read_excel(here::here("FOI/data/ATC","FOI_0917_2324_ATC_010119_010122_Westminster.xlsx"))
ATC_data

ATC_data_renamed <- ATC_data %>% rename(Hour='Start Hour')
ATC_data_renamed

accident_19_renamed <- accident_19 %>% mutate(Hour=format(as.POSIXct(time), format = "%H"))%>% rename(Date=date)
accident_19_renamed

accident_19_renamed_selected <- accident_19_renamed %>% select(accident_reference,longitude,latitude,Date,Hour)
accident_19_renamed_selected

UK_all <- map_data("world",region='UK')
UK_Britain <- UK_all %>% filter(subregion=='Great Britain')
UK_Britain

ggplot(UK_Britain, aes(long, lat)) + 
  geom_point(size = .25, show.legend = FALSE) +
  coord_quickmap()

ggplot(UK_Britain, aes(long, lat, group = group)) +
  geom_polygon(fill='white',col='grey50')+
  coord_quickmap()


accident_19_renamed_selected %>% ggplot(aes(longitude,latitude))+geom_point()
accident_19_renamed_selected
accident_counter <-  accident_19_renamed_selected %>% group_by(Date,Hour) %>% summarise(Accident_number=n())
accident_counter
ATC_data_renamed <- ATC_data_renamed %>%
  mutate(Hour = as.double(Hour))
accident_counter <- accident_counter %>%
  mutate(Hour = as.double(Hour))
ATC_data_renamed
accident_counter
joint_ATC_ACCIDENT <- ATC_data_renamed %>% left_join(accident_counter,by=c('Date','Hour'))
joint_ATC_ACCIDENT

joint_ATC_ACCIDENT_removed_NA <- joint_ATC_ACCIDENT %>% filter(!is.na(Accident_number))
joint_ATC_ACCIDENT_removed_NA

daily_volumn <- joint_ATC_ACCIDENT_removed_NA %>% group_by(Date) %>% summarise(daily_Volumn=sum(Volume))
daily_volumn

daily_accident <- joint_ATC_ACCIDENT_removed_NA %>% group_by(Date) %>% summarise(daily_accident=sum(Accident_number))
daily_accident


daily_volumn %>% ggplot(aes(Date,daily_Volumn))+geom_point()
daily_accident %>% ggplot(aes(Date,daily_accident))+geom_point()

London_shp <- st_read(here::here("FOI/data/geo/statistical-gis-boundaries-london/ESRI","London_Borough_Excluding_MHW.shp"))
Targets_shp <- London_shp %>% filter(NAME %in% c('Westminster','Lambeth',"Tower Hamlets"))
Targets_shp
# 使用ggplot绘制空间数据
ggplot(data = Targets_shp) +
  geom_sf()

stations <- read_excel(here::here("FOI/data/ATC","FOI_0917_2324_ATC_Metadata.xlsx"))
stations_sf = st_as_sf(stations,coords = c("Easting","Northing"),crs=27700)
stations_sf_trans = stations_sf %>%  st_transform(4326)
stations_sf_trans

ggplot()+geom_sf(data=Targets_shp)+geom_sf(data=stations_sf_trans,color='red',size=2)

London_road_shp = st_read(here::here("FOI/data/geo/road","gdf_london_roadlink.shp"))
target_road = London_road_shp %>% filter(NAME %in% c('Westminster','Lambeth',"Tower Hamlets"))
ggplot()+geom_sf(data=Targets_shp,color='blue',linewidth =2,fill=NA)+geom_sf(data=target_road,color='grey')+geom_sf(data=stations_sf_trans,color='red',size=2,)+ggtitle("Basic spatial distribution")


