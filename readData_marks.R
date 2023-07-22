library(tidyverse)
library(palmerpenguins)

penguins <- penguins %>% drop_na()
penguins_contains <- penguins %>% select(contains("length")) 
penguins %>% select("bill_length_mm", "flipper_length_mm")

# 虽然dplyr中select不需要通过引号输入列名，但是为了其他函数统一，建议还是以引号进行区分。


penguins %>% select(where(is.numeric))
penguins %>% select(where(is.character))
penguins %>% select(where(is.factor))

penguins %>% select(species,starts_with('bill'))

# 返回向量还是返回数据框？
# 1.向量
penguins[['species']]
# 2.dataframe
penguins['species']
# 3.vector
penguins$'species'

# 4.dataframe
penguins %>% select('species')
# 5.frame
penguins['species']

tb <- tibble(x=1.5,y=0,z=5:1,w=0)
tb

# 这是什么语法

tb %>% select(where(~sum(.x)==0))
# ~代表匿名函数Lambda,.x代表匿名函数输入变量
# 类似where(lambda x: sum(x)==0)?



df <- tibble(
  x=c(NA,NA,NA),
  y=c(2,3,NA),
  z=c(NA,5,NA)
)

# 剔除所有为NA的列
judge_na <- function(x){
  return (all(is.na(x)))
}

df %>% filter(if_any(everything(),~!is.na(.x)))

penguins %>% filter(sex=='male')

penguins %>% filter(species %in% c('Adelie','Gentoo'))

penguins %>% slice(1)

penguins %>% head(1)

penguins %>% group_by('species') %>% slice(1)

penguins %>% group_by(species) %>% slice(1)

penguins %>% arrange(desc(bill_length_mm)) %>% slice(1)

penguins %>% slice_max(bill_length_mm)

tb <- tibble::tribble(
  ~day, ~price,
  1,   "30-45",
  2,   "40-95",
  3,   "89-65",
  4,   "45-63",
  5,   "52-42"
)

tb1 <- tb %>% 
  separate(price, into = c("low", "high"), sep = "-")
tb1

tb1 %>% 
  unite(col = "price", c(low, high), sep = ":", remove = FALSE)

df <- tibble::tribble(
  ~x,~y,~z,
  1,1,1,
  1, 1, 2,
  1, 1, 1,
  2, 1, 2,
  2, 2, 3,
  3, 3, 1
)

df %>% distinct()

df %>% distinct(x)

df %>% distinct(x,y,.keep_all = TRUE)

datas = c(1,2,3,1,4,5,6,2,6,546,1,5,13)
datas %>% n_distinct()

df


df %>% group_by(x) %>% summarise(n=n_distinct(z))

penguins %>% 
  mutate(
    body = if_else(body_mass_g > 4200, "you are fat", "you are fine")
  )

df <- tibble::tribble(
  ~name,     ~type, ~score,
  "Alice", "english",    80,
  "Alice",    "math",    NA,
  "Bob", "english",    70,
  "Bob",    "math",    69,
  "Carol", "english",    NA,
  "Carol",    "math",    90
)
df %>% mutate(score=if_else(is.na(score),mean(score,na.rm = TRUE),score))

df %>% group_by(type) %>% mutate(score=if_else(is.na(score),mean(score,na.rm = TRUE),score))


penguins %>% mutate(
  body = case_when(
    body_mass_g <3500 ~ "best",
     3500<=body_mass_g & body_mass_g<4500 ~ 'good',
    body_mass_g >= 4500 & body_mass_g < 5500 ~ "general",
    TRUE~'worst'
  )
)

penguins %>% group_by(species) %>% summarise(n=n())  

penguins %>% count(sex)

penguins %>% count(counter = bill_length_mm > 40)

penguins %>% 
  mutate(is_bigger40 = bill_length_mm > 40) %>% count(is_bigger40) %>% mutate(percentage=n/sum(n))

penguins %>% summarise(across(c(bill_length_mm,bill_depth_mm),mean))

penguins %>% mutate(bill_length_mm=bill_length_mm-mean(bill_length_mm),bill_depth_mm=bill_depth_mm-mean(bill_depth_mm))

centerlized <- function(x){
  x-mean(x)
}
penguins %>% summarise(across(c(bill_length_mm),list(center = centerlized)))

# using across() and purrr style
penguins %>%
  summarise(
    across(starts_with("bill_"), ~ (.x - mean(.x)) / sd(.x))
  )

penguins %>%
  group_by(species) %>%
  summarise(
    across(ends_with("_mm"), list(mean = mean, sd = sd), na.rm = TRUE)
  )

penguins %>% group_by(sex) %>% summarise(across(starts_with('bill_'),list(min=min,max=max),na.rm=TRUE))
