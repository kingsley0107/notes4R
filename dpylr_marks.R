# 1.groupy_by函数指定列名时不要加引号
# eg. penguins %>% group_by(species) √
# eg. penguins %>% group_by("species") × 导致groupby是韩兆species这个字符串来分组，并非实际使用species列来分组，导致无法分组

# 2. select时也不需要指定列名时加引号
# eg. penguins %>% select("species")
# eg. penguins %>% select(species) 
# 结果一样，但是加入引号后需要花费额外性能进行类型转换 ---by gpt

# 3. tibble 与 tibble::tribble
# tibble传统创建data.frame方式 data.frame(a=c(...),b=c(...))
# tribble用表格形式,tribble(
# ~name_col,~name_col2,
# value1,value2
# )

# 4.across函数
# penguins %>% distinct(across(c(x,y)))

# 5.处理NA
# 凡是涉及NA的四则运算结果都会变成NA，所以需要事先移除

# sum(c(1,2,3,NA,4,5),na.rm=TRUE)

# 6.新增一列
# penguins %>% mutate(body_status = if_else(body_mass_g>4800),"you are fat","you are fine")

# 7.分组统计
# 分组统计:penguins %>% group_by(species) %>% summarise(n=n())
# tricky-way: penguins %>% count(species,(sex,...))
# penguins %>% count(counter = bill_length_mm > 40)

# 8.across函数的用法
# across(.col = (selected_column/everything()),.fns = (mean/sum...))




