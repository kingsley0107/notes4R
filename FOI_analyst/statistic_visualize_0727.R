library(tidyverse)
library(stats19)
library(readxl)
library(sf)

# prepare boroughs for spatial join
LONDON_shp <- st_read(here::here("FOI/data/geo/statistical-gis-boundaries-london/ESRI","London_Borough_Excluding_MHW.shp")) %>% st_transform(4326)
target_shp = LONDON_shp %>% filter(NAME %in% c("Westminster", "Lambeth","Tower Hamlets"))
target_shp
accident_21_raw <- read_csv(here::here("FOI/data/accident","dft-road-casualty-statistics-accident-2021.csv"))
accident_21_sf <- accident_21_raw %>% filter(!is.na(longitude) & !is.na(latitude)) %>% st_as_sf(coords=c('longitude','latitude'),crs=4326)

accident_21_processed <- filter(accident_21_sf,local_authority_ons_district %in% c("E09000030","E09000022","E09000033"))
# import data
TARGET_AREAS <- c("Westminster", "Lambeth","Tower Hamlets")
accident_19_trgs <- get_stats19(year = 2019, type = "accident") %>% filter(local_authority_district %in% TARGET_AREAS) %>% arrange(datetime)
accident_20_trgs <- get_stats19(year = 2020, type = "accident") %>% filter(local_authority_district %in% TARGET_AREAS) %>% arrange(datetime)
# accident_21_trgs <- get_stats19(year = 2021, type = "accident") %>% filter(local_authority_district %in% TARGET_AREAS) %>% arrange(datetime)
conbined_19_20 <- bind_rows(accident_19_trgs,accident_20_trgs)
conbined_19_20_21 <- bind_rows(conbined_19_20 %>% type.convert(),accident_21_processed %>% type.convert() )
Westminster_accident <- conbined_19_20 %>% filter(local_authority_district=='Westminster')
Lambeth_accident <- conbined_19_20 %>% filter(local_authority_district=='Lambeth')
Hamlets_accident <- conbined_19_20 %>% filter(local_authority_district=='Tower Hamlets')
conbined_19_20 %>% group_by(date) %>% summarise(accident=n()) %>% ggplot()+geom_line(aes(x=date,y=accident))



     