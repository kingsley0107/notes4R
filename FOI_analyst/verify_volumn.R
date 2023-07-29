library(tidyverse)
library(readxl)

# 按照方向

ATC_Westminster <- read_excel(here::here("FOI/data/ATC","FOI_0917_2324_ATC_010119_010122_Westminster.xlsx"))
ATC_Westminster %>% group_by(Date) %>% summarise(Volume_count=sum(Volume)) %>% ggplot() + geom_line(aes(x=Date,y=Volume_count))+scale_y_continuous(limits = c(0, NA))

ATC_Westminster %>%group_by(Date) %>%   summarise(Volume_count=sum(Volume)) %>% summarise(Volume=sum(Volume_count),mean=mean(Volume_count),median=median(Volume_count),sd=sd(Volume_count),min=min(Volume_count),max=max(Volume_count))

ggplot(ATC_Westminster %>% group_by(Date,Direction) %>% summarise(count=sum(Volume)), aes(x = Date, y = count)) +
  geom_line() +
  facet_wrap(~ Direction, ncol = 4) +scale_y_continuous(limits = c(0, NA))

ATC_Westminster %>% group_by(Direction) %>% summarise(Volume_count=sum(Volume),mean=mean(Volume),median=median(Volume),sd=sd(Volume),min=min(Volume),max=max(Volume))
# Direction
ggplot(ATC_Westminster %>% group_by(Date,Direction) %>% summarise(count = sum(Volume)))+geom_boxplot(aes(x=Direction,y=count,group=Direction))+scale_y_continuous(limits = c(0, NA))+ggtitle("Direction boxplot for Westminster")

ATC_Lambeth <- read_excel(here::here("FOI/data/ATC","FOI_0917_2324_ATC_data_010119_010122_Lambeth.xlsx"))
ATC_Lambeth %>% group_by(Date) %>% summarise(Volume_count=sum(Volume)) %>% ggplot() + geom_line(aes(x=Date,y=Volume_count))+scale_y_continuous(limits = c(0, NA))

ATC_Lambeth %>% group_by(Direction) %>% summarise(Volume_count=sum(Volume),mean=mean(Volume),median=median(Volume),sd=sd(Volume),min=min(Volume),max=max(Volume))

ggplot(ATC_Lambeth %>% group_by(Date,Direction) %>% summarise(count=sum(Volume)), aes(x = Date, y = count)) +
  geom_line() +
  facet_wrap(~ Direction, ncol = 4) +scale_y_continuous(limits = c(0, NA))

# Direction
ggplot(ATC_Lambeth %>% group_by(Date,Direction) %>% summarise(count = sum(Volume)))+geom_boxplot(aes(x=Direction,y=count,group=Direction))+scale_y_continuous(limits = c(0, NA))+ggtitle("Direction boxplot for Lambeth")

ATC_TowerHamlets <- read_excel(here::here("FOI/data/ATC","FOI_0917_2324_ATC_data_010119_010122_Tower_Hamlets.xlsx"))
ATC_TowerHamlets %>% group_by(Date) %>% summarise(Volume_count=sum(Volume)) %>% ggplot() + geom_line(aes(x=Date,y=Volume_count))+scale_y_continuous(limits = c(0, NA))

ggplot(ATC_TowerHamlets %>% group_by(Date,Direction) %>% summarise(count=sum(Volume)), aes(x = Date, y = count)) +
  geom_line() +
  facet_wrap(~ Direction, ncol = 4) +scale_y_continuous(limits = c(0, NA))
# Direction
ggplot(ATC_TowerHamlets %>% group_by(Date,Direction) %>% summarise(count = sum(Volume)))+geom_boxplot(aes(x=Direction,y=count,group=Direction))+scale_y_continuous(limits = c(0, NA))+ggtitle("Direction boxplot for Tower Hamlet")

ATC_TowerHamlets %>% group_by(Direction) %>% summarise(Volume_count=sum(Volume),mean=mean(Volume),median=median(Volume),sd=sd(Volume),min=min(Volume),max=max(Volume))
# Hourly
ATC_Westminster['Hour'] = ATC_Westminster['Start Hour']
ATC_Westminster$Hour <- factor(ATC_Westminster$Hour,levels=0:23)
ATC_Westminster %>% ggplot() + geom_boxplot(aes(x=Hour,y=Volume,group=Hour))+ggtitle("Westminster Hourly Volume")

ATC_Lambeth['Hour'] = ATC_Lambeth['Start Hour']
ATC_Lambeth$Hour <- factor(ATC_Lambeth$Hour,levels=0:23)
ATC_Lambeth %>% ggplot() + geom_boxplot(aes(x=Hour,y=Volume,group=Hour))+ggtitle("Lambeth Hourly Volume")


ATC_TowerHamlets['Hour'] = ATC_TowerHamlets['Start Hour']
ATC_TowerHamlets$Hour <- factor(ATC_TowerHamlets$Hour,levels=0:23)
ATC_TowerHamlets %>% ggplot() + geom_boxplot(aes(x=Hour,y=Volume,group=Hour))+ggtitle("Tower Hamlet Hourly Volume")


