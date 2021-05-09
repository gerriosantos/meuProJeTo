

# grudar <- function(base1, base2, chave1, chave2){
#   `%>%` <- magrittr::`%>%`
#
#   base1 %>% dplyr::left_join(base2, by = c({{chave1}}={chave2}))
# }
#
# dados <- grudar(base1 = h, base2 = casos, chave1 = 'codibge', chave2 = 'city_ibge_code')



dados <- dplyr::left_join(h, casos, by = c('codibge'='city_ibge_code')) %>%
  dplyr::relocate(city:deaths, .before = reeleicao)
