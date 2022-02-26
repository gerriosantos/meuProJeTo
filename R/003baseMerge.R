

# grudar <- function(base1, base2, chave1, chave2){
#   `%>%` <- magrittr::`%>%`
#
#   base1 %>% dplyr::left_join(base2, by = c({{chave1}}={chave2}))
# }
#
# dados <- grudar(base1 = h, base2 = casos, chave1 = 'codibge', chave2 = 'city_ibge_code')



dados <- dplyr::left_join(h, casos, by = c('codibge'='city_ibge_code')) %>%
  dplyr::relocate(city:deaths, .before = reeleicao)


readr::write_rds(dados, 'data/dados.rds')



# `%>%` <- magrittr::`%>%`
# mob <- readr::read_rds('data-raw/mob_google_mun.RDS') %>%
#   dplyr::filter(sigla_uf == 'CE') %>%
#   dplyr::select(cod_municipio7, indice_mob = localTrab) %>%
#   dplyr::left_join(dados, by = c('cod_municipio7'='codibge')) %>%
#   tidyr::drop_na(deaths_100k)
#
# reg_m_2 <- lm(data =  mob, log(deaths_100k) ~ d_reeleicao + indice_mob)
#
# summary(reg_m_2)
#
#
# reg_m_2 <- fixest::feols(data =  mob, log(deaths_100k) ~ d_reeleicao + indice_mob)
#
# fixest::etable(reg_m_2, cluster = 'cod_municipio7' ,  se = 'cluster')






