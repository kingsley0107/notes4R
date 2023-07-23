library(tidyverse)

# 1.expand
# ?expand
# 将多列进行笛卡尔积
# eg.
# df <- data.frame(A = c("X", "Y"), B = c(1, 2))
# expanded_df <- expand(df, A, B)
# > expanded_df
# # A tibble: 4 × 2
# A         B
# <chr> <dbl>
#   1 X         1
# 2 X         2
# 3 Y         1
# 4 Y         2

# 2.nesting函数
# 当你想对A\B两列对Z列进行笛卡尔积时:
# (即A,B)组合视为一个整体对Z进行笛卡尔积:
# df %>% expand(nesting(A,B))

# 3.expand_grid与crossing
# expand_grid即对多列进行笛卡尔积
# expand_grid(x = c(1, 1), y = c(1:2))
# ->## 1     1     1
## 2     1     2
## 3     1     1
## 4     1     2

# crossing(x = c(1, 1), y = c(1:2))    # 考虑去重 
## 1     1     1
## 2     1     2

# 4.sperate,unite与extract

# tb <- tibble::tribble(
# ~day, ~price,
# 1,   "30-45",
# 2,   "40-95",
# 3,   "89-65",
# 4,   "45-63",
# 5,   "52-42"
# )

# tb1 <- tb %>%
# separate(price, into = c("low", "high"), sep = "-")
# tb1
# 
## # A tibble: 5 × 3
##     day low   high 
##   <dbl> <chr> <chr>
## 1     1 30    45   
## 2     2 40    95   
## 3     3 89    65   
## 4     4 45    63   
## 5     5 52    42

# tb1 %>%
# unite(col = "price", c(low, high), sep = ":", remove = FALSE)

## # A tibble: 5 × 4
##     day price low   high 
##   <dbl> <chr> <chr> <chr>
## 1     1 30:45 30    45   
## 2     2 40:95 40    95   
## 3     3 89:65 89    65   
## 4     4 45:63 45    63   
## 5     5 52:42 52    42


# extract使用正则表达式
# dfc <- tibble(x = c("1-12week", "1-10wk", "5-12w", "01-05weeks"))
# dfc
## # A tibble: 4 × 1
##   x         
##   <chr>     
## 1 1-12week  
## 2 1-10wk    
## 3 5-12w     
## 4 01-05weeks

# dfc %>% tidyr::extract(
# x,
# c("start", "end", "letter"), "(\\d+)-(\\d+)([a-z]+)",
# remove = FALSE
# )

# ## # A tibble: 4 × 4
##   x          start end   letter
##   <chr>      <chr> <chr> <chr> 
## 1 1-12week   1     12    week  
## 2 1-10wk     1     10    wk    
## 3 5-12w      5     12    w     
## 4 01-05weeks 01    05    weeks

df <- tibble::tribble(
  ~name,     ~type, ~score, ~extra,
  "Alice", "english",     80,     10,
  "Alice",    "math",     NA,      5,
  "Bob", "english",     NA,      9,
  "Bob",    "math",     69,     NA,
  "Carol", "english",     80,     10,
  "Carol",    "math",     90,      5
)

df