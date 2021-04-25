

`%>%` <- magrittr::`%>%`


df <- mtcars %>% dplyr::filter(cyl  > 10 & disp > 100)
df


readr::write_rds(df, 'data/df.rds')
