library(tidyverse)
library(readxl)
library(stats19)

# 1.时序变化
# 2.按星期几变化
# 3.按小时变化
# 4.关联天气

extract_daily <- function(df,date2,index){
  
  df %>% group_by({{date2}}) %>% summarise({{index}}:=n())
}

# read data

df_2019_raw <- read_csv(here::here("FOI/data/accident/gov","dft-road-casualty-statistics-accident-2019.csv"))
df_2020_raw <- read_csv(here::here("FOI/data/accident/gov","dft-road-casualty-statistics-accident-2020.csv"))
df_2021_raw <- read_csv(here::here("FOI/data/accident/gov","dft-road-casualty-statistics-accident-2021.csv"))

# process for date
df_2019_daily <- extract_daily(df_2019_raw,date,accidents)
df_2020_daily <- extract_daily(df_2020_raw,date,accidents)
df_2021_daily <- extract_daily(df_2021_raw,date,accidents)

# visualize_by_date with geom_line

df_daily <- bind_rows(df_2019_daily,df_2020_daily,df_2021_daily) %>% mutate(date=as.Date(date,format="%d/%m/%Y"))
df_daily %>% summarise(mean=mean(accidents),median=median(accidents),sum=sum(accidents),sd=sd(accidents),min=min(accidents),max=max(accidents))
df_daily %>% ggplot(aes(date,accidents))+geom_line()+scale_x_date(date_labels = "%b %Y", date_breaks = "3 month")+ggtitle("daily accidents")

# process for dayofweek

df_dayofweek_19 <- df_2019_raw %>% select(date,day_of_week)
df_dayofweek_20 <- df_2020_raw %>% select(date,day_of_week)
df_dayofweek_21 <- df_2021_raw %>% select(date,day_of_week)

df_day_of_week <- bind_rows(df_dayofweek_19,df_dayofweek_20,df_dayofweek_21) %>% mutate(date=as.Date(date,format="%d/%m/%Y"))
df_groupped <- df_day_of_week %>% group_by(date,day_of_week) %>% summarise(accident=n())
df_groupped$day_of_week <- factor(df_groupped$day_of_week, levels = c(1, 2, 3, 4, 5, 6, 7))
# statistic
df_groupped %>% group_by(day_of_week) %>% summarise(accidents=sum(accident),mean=mean(accident),median=median(accident),sd=sd(accident),min=min(accidents),max=max(accidents))
# visualize from day of week
ggplot(data=df_groupped,aes(x=day_of_week,y=accident))+geom_boxplot(aes(group=day_of_week))+ggtitle("summarised by day of week")


# 3.按小时
df_2019_hour <- df_2019_raw %>% select(date,time)
df_2020_hour <- df_2020_raw %>% select(date,time)
df_2021_hour <- df_2021_raw %>% select(date,time)
df_hour <- bind_rows(df_2019_hour,df_2020_hour,df_2021_hour)
df_hour$hour <- as.integer(substr(df_hour$time,1,2))
df_hour$hour <- factor(df_hour$hour, levels =0:23)
df_hour %>% group_by(date,hour) %>% summarise(accident=n()) %>% ggplot()+geom_boxplot(aes(hour,accident,group=hour))+ggtitle("Hourly accidents")

# 4.关联天气
df_19_weather <-  df_2019_raw %>% select(date,weather_conditions)
df_20_weather <-  df_2020_raw %>% select(date,weather_conditions)
df_21_weather <-  df_2021_raw %>% select(date,weather_conditions)

df_weather <- bind_rows(df_19_weather,df_20_weather,df_21_weather) 
df_weather$weather_conditions <- factor(df_weather$weather_conditions, levels = -1:9)
df_weather %>% group_by(date,weather_conditions) %>% summarise(accident=n()) %>% ggplot()+geom_boxplot(aes(weather_conditions,accident,group=weather_conditions))
df_weather %>% group_by(weather_conditions) %>% summarise(accident=n())

# 5.关联speed limit

df_speed_19 <- df_2019_raw %>% select(date,speed_limit)
df_speed_20 <- df_2020_raw %>% select(date,speed_limit)
df_speed_21 <- df_2021_raw %>% select(date,speed_limit)
df_speed <- bind_rows(df_speed_19,df_speed_20,df_speed_21)
df_speed$speed_limit <- factor(df_speed$speed_limit, levels = c(-1,10:70))
df_speed %>% group_by(date,speed_limit) %>% summarise(accident=n()) %>% ggplot()+geom_boxplot(aes(speed_limit,accident,group=speed_limit))

df_speed %>% group_by(speed_limit) %>% summarise(accident=n())
