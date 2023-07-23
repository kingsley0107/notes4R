library(tidyverse)
library(palmerpenguins)
library(forcats)
income <- c("low", "high", "medium", "medium", "low", "high",  "high")
# sort by the first letter
fact_income <- factor(income)
fact_income

factor(income, levels = c("low", "high") )#levels without medium
fact_income
fact_income %>% fct_relevel(c("high",'medium','low'))

fact_income %>% fct_relevel("medium")
fact_income %>% fct_relevel("medium",after=Inf)

fact_income %>% fct_inorder()

d <- tibble(
  x = c("a","a", "b", "b", "c", "c"),
  y = c(2, 2, 1, 5,  0, 3)
  
)
d %>% 
  ggplot(aes(x = fct_reorder(x,y,.fun=median,.desc=TRUE), y = y)) +
  geom_point()
# 更可读的写法:
d %>% 
  mutate(x=fct_reorder(x,y,.fun=median,.desc=TRUE)) %>% 
  ggplot(aes(x=x,y=y))+
  geom_point()


library(gapminder)
gapminder %>%
  filter(
    year == 2007,
    continent == "Americas"
  )

gapminder %>%
  filter(
    year == 2007,
    continent == "Americas"
  ) %>% ggplot(aes(x=country,y=lifeExp))+  geom_col()

# 目前为止对因子的作用停留在ggplot时 x y轴绘图顺序的调换调正.
