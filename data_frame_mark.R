# tibble是data.frame的一个子类

# tibble特有的关联创造方式
library(tidyverse)

tb <- tibble(
  x=1:3,
  y=x+2
)

tb

# 这种关联创造是data.frame无法做到的


# 另一种更直观的创造tibble的方式(仅适用于数据量不大时，相当于直接画出一个excel)
trb <- tribble(
  ~x,~y,~z,
  1,2,3,
  4,5,6,
  7,8,9
)
trb

# 非tibble类型转换tibble类型
# 1.data.frame转tibble
# 2.vector转tibble
# 3.list转tibble
# 4.matrix转tibble

iris
t1 <- iris[1:6,1:4]
class(t1)#data.frame
typeof(t1)#list?

# 1.data.frame转tibble
as_tibble(t1)

# 2.vector转tibble
class(1:5)
as_tibble((1:5))

# 3.list转tibble
list(x = 1:6, y = runif(6), z = 6:1)
as_tibble(list(x = 1:6, y = runif(6), z = 6:1))
# tibble转list?
as.list(as_tibble(list(x = 1:6, y = runif(6), z = 6:1)))


# 4.matrix转tibble
matrix(rnorm(15),nrow = 5)
as_tibble(matrix(rnorm(15),nrow = 5))

# 操作tibble
# 1.构建
df <- tibble(
  x=1:5,
  y=x+99
)

# 2.新增一列
add_column(df,z=0:4,w=0)

# 3.新增一行
add_row(df,x=99,y=9)

# 4.在第二行前,新增一行
add_row(df,x=123,y=456,.before = 2)



# 读取文件
read.csv(here::here("data/demo_data","wages.csv"))

# tibble列名重复问题
tibble(x=1,x=2,.name_repair = 'minimal')
tibble(x=1,x=2,.name_repair = 'unique')
tibble(x=1,x=2,.name_repair = 'universal')
