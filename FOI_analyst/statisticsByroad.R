library(tidyverse)
library(sf)
library(readxl)
library(lubridate)
# options(ragg.max_dim = 1000000)
road_data <- st_read(here::here("FOI/data/geo/road","ATC_stations_road.geojson"))
reference_table <- read_csv(here::here("FOI/data","reference_table_station_selected.csv"))
reference_table <- reference_table %>% mutate(hour = hour(time))
reference_table <- reference_table %>%
  mutate(date = format(dmy(date), "%Y-%m-%d"))
Westminster_flow <- read_excel(here::here("FOI/data/ATC","FOI_0917_2324_ATC_010119_010122_Westminster.xlsx"))
Lambeth_flow <- read_excel(here::here("FOI/data/ATC","FOI_0917_2324_ATC_data_010119_010122_Lambeth.xlsx"))
Hamlets_flow <- read_excel(here::here("FOI/data/ATC","FOI_0917_2324_ATC_data_010119_010122_Tower_Hamlets.xlsx"))



Westminster_flow['Hour']= Westminster_flow['Start Hour']
Westminster_flow <- mutate(Westminster_flow,Day = as.character(as_date(Date)))
Westminster_flow_sum <- Westminster_flow  %>% group_by(SiteNo,Date,Hour) %>% summarise(Volume_sum=sum(Volume))
Westminster_flow_sum <- mutate(Westminster_flow_sum,Day = as.character(as_date(Date)))

Lambeth_flow['Hour']= Lambeth_flow['Start Hour']
Lambeth_flow <- mutate(Lambeth_flow,Day = as.character(as_date(Date)))
Lambeth_flow_sum <- Lambeth_flow  %>% group_by(SiteNo,Date,Hour) %>% summarise(Volume_sum=sum(Volume))
Lambeth_flow_sum <- mutate(Lambeth_flow_sum,Day = as.character(as_date(Date)))

Hamlets_flow['Hour']= Hamlets_flow['Start Hour']
Hamlets_flow <- mutate(Hamlets_flow,Day = as.character(as_date(Date)))
Hamlets_flow_sum <- Hamlets_flow  %>% group_by(SiteNo,Date,Hour) %>% summarise(Volume_sum=sum(Volume))
Hamlets_flow_sum <- mutate(Hamlets_flow_sum,Day = as.character(as_date(Date)))

traffic_flow_all <- bind_rows(Westminster_flow_sum,Lambeth_flow_sum,Hamlets_flow_sum)
reference_table

for (i in 1:nrow(reference_table)){
  this_site <- reference_table[[i,'Site_No']]
  this_date <- reference_table[[i,'date']]
  this_hour <- reference_table[[i,'hour']]
  
  # Calculate the date range for 7 days before and after this_day
  start_date <- as.Date(this_date) - 7
  end_date <- as.Date(this_date) + 7
  
  traffic_plot <- traffic_flow_all %>%
    filter(SiteNo == this_site, Day >= start_date, Day <= end_date)
  
  # Create a new logical column to identify the specified hour range
  traffic_plot$highlight <- (traffic_plot$Hour >= (this_hour - 1) & traffic_plot$Hour <= (this_hour + 1))
  
  # Convert Hour to POSIXct for x-axis display
  traffic_plot$Datetime <- as.POSIXct(paste(traffic_plot$Day, traffic_plot$Hour, sep=" "), format="%Y-%m-%d %H")
  
  # Using geom_line to create the traffic flow data plot
  plot <- ggplot(traffic_plot, aes(x = Datetime, y = Volume_sum)) +
    geom_line(color = "#0072B2", size = 1) +  # Adjust line color and size for the traffic flow line
    ggtitle(paste(paste(this_date, this_hour, sep=" "),":00",sep = "")) +
    labs(x = "Datetime", y = "Volume Sum") +
    theme_minimal()  # Using minimal theme for a cleaner look
  
  daily_this_hour <- filter(traffic_plot, Hour == this_hour)
  
  # Adding a dashed red vertical line to point at this_hour
  plot <- plot + geom_vline(xintercept = as.POSIXct(paste(this_date, this_hour, sep=" "), format="%Y-%m-%d %H"),
                            linetype = "dashed", color = "red",size=2)
  
  # Adjusting x-axis time range to include 7 days before and after this_day
  plot <- plot + scale_x_datetime(date_breaks = "1 day", date_labels = "%b %d %H:%M", 
                                  limits = c(as.POSIXct(paste(start_date, "00:00", sep=" "), format="%Y-%m-%d %H:%M"),
                                             as.POSIXct(paste(end_date, "23:59", sep=" "), format="%Y-%m-%d %H:%M")))
  
  # Plotting daily_this_hour as a blue line with round data points
  plot <- plot + geom_line(data = daily_this_hour, aes(x = Datetime, y = Volume_sum), color = "#FFA8A0", size = 1.5) +
    geom_point(data = daily_this_hour, aes(x = Datetime, y = Volume_sum), color = "#56B4E9", size = 3, shape = 16)+
    ylim(0,1000)# Adjust line color, size, and point shape
  file_name <- paste(this_site, this_date, this_hour, sep = "_")
  file_name <- paste(file_name, ".png", sep = "")
  print(plot)
  ggsave(paste("C:/Users/20191/Documents/Rprojects/FOI/images/statistic/Accident/",file_name,sep=""), plot,  width = 80, height = 40, dpi = 300, limitsize = FALSE)

}