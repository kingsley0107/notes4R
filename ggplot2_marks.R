library(tidyverse)
library(ggplot2)


# 1.ggplot通用范式:
# ggplot(data=<DATA>)+<geom_function>(mapping=aes(x=<>,y=<>))
# 
# ggplot(data=d)+geom_point(mapping=aes(x=year,y=carbon_emissions))
#   +xlab("Year")+ylab("Carbon emissions (metric tons)")+
#   ggtitle("Annual global carbon emmisions")

# 2.关于mapping内的color问题
# eg. ggplot(penguins)+geom_point(aes(x=bill_length_mm,y=bill_depth_mm,color='blue'))
# eg. ggplot(penguins)+geom_point(aes(x=bill_length_mm,y=bill_depth_mm),color='blue')
# 第一个eg中，color被放置在了aes内部，但映射需要以变量进行赋值，mapping内部并不认识'blue'，因此绘出图画会变红色
# 第二个eg，color在geom_point内部，因此有效，成为蓝色。

# 3.Global vs. Local
# eg. ggplot(data=penguins,aes(x=bill_length_mm,y=bill_depth_mm))+geom_point()
# eg. ggplot(data=penguins)+geom_point(aes(x=bill_length_mm,y=bill_depth_mm))
# 两图一样.在ggplot中声明aes，将成为以下子geom_graphic对象的全局对象属性，当子对象中缺失该属性时，会从全局中取出。
# 当子属性不缺失，则直接采用子属性。


# 4.引号问题
# eg. ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
# geom_point(aes(color=species)) +
#   geom_smooth() +
#   geom_smooth(aes(color=species)) 
# 在ggplot中，aes内不需要将列名加入引号''，ggplot内部会自动识别其为一个列名。



penguins <- read.csv(here::here("data/demo_data","penguins.csv"))
penguins %>% select(species,sex,bill_length_mm,bill_depth_mm)

ggplot(data=penguins) + geom_point(aes(x=bill_length_mm,y=bill_depth_mm,color=species))  

ggplot(penguins) +
  geom_point(aes(x = bill_length_mm, y = bill_depth_mm, size = species))

ggplot(penguins) +
  geom_point(aes(x = bill_length_mm, y = bill_depth_mm, shape = species))

ggplot(penguins) +
  geom_point(
    aes(x = bill_length_mm, y = bill_depth_mm, color = species, alpha = sex)
  )
# args(geom_point)

ggplot(penguins)+geom_point(aes(x=bill_length_mm,y=bill_depth_mm))
ggplot(penguins)+geom_point(aes(x=bill_length_mm,y=bill_depth_mm),color='blue')

ggplot(penguins)+geom_smooth(aes(x=bill_length_mm,y=bill_depth_mm),method="lm")

ggplot(penguins)+geom_point(aes(x=bill_length_mm,y=bill_depth_mm),color='blue')+geom_smooth(aes(x=bill_length_mm,y=bill_depth_mm),method="lm")


ggplot(penguins,aes(x=bill_length_mm,y=bill_depth_mm,color=species))+geom_point()+geom_smooth()

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(aes(color = species)) +
  geom_smooth()

p1 <- ggplot(penguins,aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point(aes(color = sex))
p1
ggsave(plot=p1,filename="my_first_plot.pdf",height=8,width=6,dpi=300)

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(aes(color=species)) +
  geom_smooth() +
  geom_smooth(aes(color=species)) 
