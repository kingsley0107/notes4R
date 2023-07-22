library(tidyverse)

# 数据透视表
# pivot_longer:宽变长
# pivot_wider:长变宽

# pivot_longer:
# args:
#     cols:哪些列需要转换
#     names_to: cols中选取的列将转化为longer的一列，这些列合并后叫什么？
#     values_to:值所在的列叫什么？

# R语言中的.xxx
# 意味深长，.xxx通常代表匹配到的vars
# pivot_longer(
# cols=!day,
# names_to = c("species",".value")
# names_pattern = "(.*)_(.*)"
# )

# 其中的.value就是正则后一项匹配的var。
# 包括匿名函数的lambda: ~sum(.x) ~~~ lambda x: sum(x)

plant_height <- data.frame(
  Day = 1:5,
  A = c(0.7, 1.0, 1.5, 1.8, 2.2),
  B = c(0.5, 0.7, 0.9, 1.3, 1.8),
  C = c(0.3, 0.6, 1.0, 1.2, 2.2),
  D = c(0.4, 0.7, 1.2, 1.5, 3.2)
)


long <- plant_height %>% pivot_longer(cols=A:D,names_to = "plant",values_to = "height")
ggplot(data=long) + geom_line(aes(x=Day,y=height,color=plant))

wide <- long %>% pivot_wider(names_from = plant,values_from = height)
wide


plant_record <- data.frame(
  day = c(1L, 2L, 3L, 4L, 5L),
  A_height = c(1.1, 1.2, 1.3, 1.4, 1.5),
  A_width = c(2.1, 2.2, 2.3, 2.4, 2.5),
  A_depth = c(3.1, 3.2, 3.3, 3.4, 3.5),
  B_height = c(4.1, 4.2, 4.3, 4.4, 4.5),
  B_width = c(5.1, 5.2, 5.3, 5.4, 5.5),
  B_depth = c(6.1, 6.2, 6.3, 6.4, 6.5),
  C_height = c(7.1, 7.2, 7.3, 7.4, 7.5),
  C_width = c(8.1, 8.2, 8.3, 8.4, 8.5),
  C_depth = c(9.1, 9.2, 9.3, 9.4, 9.5)
)

plant_record %>% pivot_longer(
  cols = !day,
  names_to = c("species","parameter"),
  names_pattern="(.*)_(.*)",
  values_to="value"
)

plant_record_longer <- plant_record %>% 
  tidyr::pivot_longer(
    cols = !day,
    names_to = c("species", ".value"),
    names_pattern = "(.*)_(.*)"
  )
plant_record_longer
