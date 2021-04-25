

`%>%` <- magrittr::`%>%`


df <- mtcars %>% dplyr::filter(cyl  > 5)
df


readr::write_rds(df, 'data/df.rds')
